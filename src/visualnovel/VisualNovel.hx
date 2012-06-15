package visualnovel;
import toolbar.HorizontalBar;
import toolbar.VerticalBar;
import buildingblocks.Tile;
import controls.IconsControl;
import controls.TextControl;
import controls.InputControl;
import datastructures.Tree;
import animation.Spotlight;

import js.JQuery;

class VisualNovel extends Tile {
	/****
	* Private member variables
	***/
	// Scene storage
	private var scenes : Hash<Scene>; // all loaded scenes
	private var scene_tree : TreeNode<Int>; // tree root
	
	// choice storage
	private var forks : Hash<Fork>; // all the forks for the scenes
	private var active_forks : Array<Fork>; // the forks currently shown on a given scene
	
	// navigation logic
	private var active_scene : TreeNode<Int>; // Furthest scene we have reached
	private var shown_scene : TreeNode<Int>; // the scene that's actually shown
	private var past_history : List<TreeNode<Int>>; // history of all the scenes we've visted
	private var future_history : List<TreeNode<Int>>; // history of all the scenes we've revisited
	
	// UI
	private var loading : Tile; // Now-Loading animation
	private var selector : VerticalBar; // Choice making dialog
	private var ui : Hash<Tile>; // buttons, clickers, etc.
	
	// animation / highlights
	private var spotlight : Spotlight; // used to highlight stuff
	
	// user permission management
	private var permission : Int; // permission levels
	private var edit_flag : Bool; // false = normal, true = edit
	private var tabs : HorizontalBar; // Control bar
	
	// External callback interface
	private var fork_callto : (Int -> Void) -> Void; // server-communication use 
	private var commit_callto : Array<SceneData> -> Void ; // saves data to server 
	
	/****
	* Public Setup (YOU MUST CALL ALL OF THEM!)
	***/
	// Starts off the visual novel at the root scene
	public function Start() : Scene { 
		// Step 1: Navigate to the root scene
		this.active_scene = this.scene_tree;
		this.shown_scene = this.active_scene;
		this.past_history = new List();
		this.future_history = new List();
		this.past_history.push(this.active_scene);
		
		// Step 2: Hide EVERYTHING
		this.Hide();
		
		// Step 3: Show everything again
		this.Show(); 
		this.p_prepareforks();
			
		// Step 4: Fish out the scene in question
		this.loading.Hide();
		return this.scenes.get(this.active_scene.Data() + "");
	} // Start
	
	public function Load( data : Array<SceneData> ): Void { 
		// Step 0: Temporary anonymous function
		var lambda_FindChildren = function( t : TreeNode<Int> ) { 
			var children : Array<TreeNode<Int>> = [];
			for( k in 0...data.length ) { 
				if( t.Data() == data[k].parent_id ) { 
					children.push( t.Branch(data[k].id) );
				} // if
			} // for k
			// trace(children);
			return children;
		}; // FindChildren
		
		// Step 1: Load up scenes
		this.scenes = new Hash<Scene>();
		this.scene_tree = null;
		for( k in 0...data.length ) {
			var scene = new Scene();
			scene.Load(data[k]);
			scene.Hide();
			this.scenes.set(data[k].id + "", scene );
			if ( data[k].parent_id == null ) { 
				this.scene_tree = Tree.Create(data[k].id);
			} // if
		} // for k
		this.active_scene = this.scene_tree;
		
		// Step 1.5: Loading forks
		this.forks = new Hash<Fork>();
		for( k in 0...data.length) { 
			var happycat = new Fork();
			happycat.Load(data[k]); // fork.load
			this.forks.set(happycat.GetHash(), happycat);
		} // for
		
		// Step 2: Error-handling
		if ( this.scene_tree == null ) { 
			throw "Bad scene data - attempted cirrcular tree depedence. Seriously, please don't write trees that are their own parents";
		} // if
		
		// Step 3: Loading scene_tree data
		var leafs : Array<TreeNode<Int>> = lambda_FindChildren( this.scene_tree );
		var children : Array<TreeNode<Int>> = [];
		while( leafs.length > 0 ) {
			children = [];
			for( k in 0...leafs.length ) {
				// Fixed a ridiculous issue with concat not altering the original vector 
				children = children.concat( lambda_FindChildren(leafs[k]) );
			} // for
			// trace(children);
			leafs = children;
		} // while

	} // Load
	
	// -1 = b& user
	// 0 = anonymous user
	// 1 = regular user
	// 2 = collaborator
	// 3 = owner
	// 4 = mod
	// 5 = admin
	public function SetupPermission( level : Int ) { 
		this.permission = level;
	} // SetupPermission 
	
	public function SetupForking( cb ){ 
		this.fork_callto = cb;
	} // SetupForking
	
	public function SetupCommitting( cb ) { 
		this.commit_callto = cb;
	} // SetupSaving
	 
	/****
	* Public methods
	***/
	public function new() { 
		// Step 1: New junk
		super();
		this.tabs = new HorizontalBar();
		this.ui = new Hash<Tile>();
		this.loading = new Tile();
		this.spotlight = new Spotlight();
		this.selector = new VerticalBar();
		this.permission = 0;
		this.edit_flag = false;
		
		// Step 2: Set UI
		this.selector.ClassName("visualnovel-forkbox");
		this.loading.Show();
		this.loading.HTML("<h4 class=\"now-loading\">Now Loading...</h4>");
		this.loading.ClassName("visualnovel-placeholder now-loading");
		this.tabs.ClassName("visualnovel-tabs-holder");
		
		this.tabs.Text("Text", function(){ return; } );
		this.tabs.Text("Image", function(){ return; } );
		
		// Step 3: Setup clickables
		this.p_setupui();
	} // new
	
	// Call this function to save the current state to the server
	public function Commit() { 
		// Step 0: Declare variables
		var lambda_generatestate = function(history : List<TreeNode<Int>>) { 
			var temp_history = new List<TreeNode<Int>>();
			var full_state = [];
			while( history.first() != null ) { 
				var self_node = history.pop();
				temp_history.push(self_node);
				var scene_state = this.scenes.get( self_node.Data() + "" ).GetState();
				var fork_node = this.forks.get(self_node.Parent() + "-" + self_node.Data());
				for( lolcat in self_node.Children() ) { 
					scene_state.children_id.push( lolcat.Data() );
				} // for lolcat
				scene_state.id = self_node.Data();
				scene_state.parent_id = self_node.Parent();
				scene_state.fork_number = fork_node.Choice();
				scene_state.fork_text = fork_node.Text();
				full_state.push(scene_state);
			} // while
			while( temp_history.first() != null ) { 
				history.push( temp_history.pop() );
			} // while
			return full_state;
		}; // lambda_generatestate
		
		// Step 1: Go through the past history
		var fullstate = lambda_generatestate( this.past_history );
		
		// Step 2: Go through the future history
		fullstate = fullstate.concat( lambda_generatestate( this.future_history ) );
		
		// Step 3: Callto the server
		this.commit_callto(fullstate);
	} // Save
	
	// Toggles between regular mode and edit mode
	public function Edit(?flag : Bool) { 
		// Toggle the flag
		this.edit_flag = flag != null ? flag : !(this.edit_flag);
		trace(this.edit_flag);
		this.scenes.get(this.shown_scene.Data() + "").Edit(this.edit_flag);
		this.p_edittools();
			
	} // Edit
	
	// Creates a new scene and attaches it wherever we are
	//                                / - (s4 a)        
	// (s1) - (s2) - (s3) (forked here) - (s4) - (s5) (forked here) - (s6)
	//                                                           \ - (s6 a)
	// New scenes should only be initialized when we get an ID from the server
	// Notice that this method is in parallel
	public function Fork(text : String, cb : Scene -> Void ) : Void {
		this.fork_callto( function( id : Int ) { 
			var scene = new Scene();
			var scenedata = { 
				layers : [],
				text : "",
				id : id ,
				parent_id : this.active_scene.Data() ,
				children_id : [] ,
				fork_text : text ,
				fork_image : null ,
				fork_number : this.active_scene.Children().length
			}; // scenedata
			this.active_scene.Branch(id);
			scene.Load(scenedata);
			this.scenes.set(id + "", scene);
			this.Next(this.active_scene.Children().length - 1);
			cb(scene);
		} ); // fork_callto callback 
	} // Fork
	
	// Goes to the next scene ( defaults to first path )
	public function Next( ?choice : Int ) : Void { 
		this.selector.Hide();
		// Step 0: History navigation
		if ( this.future_history.last() != null ) { 
			// Step a: Hide the current scene
			this.scenes.get(this.shown_scene.Data() + "").Hide();
			
			// Step b: Find the scene from history
			var back2future = this.future_history.pop();
			this.past_history.push(back2future);
			var scene = this.scenes.get(back2future.Data() + "");
			this.shown_scene = back2future;
			
			// Step c: Show the history scene
			scene.Show();
			
			// Step 3.5 Managing edit mode
			scene.Edit(this.edit_flag);
		} // if
		else { 
			// Step 1: Null checking
			if ( this.active_scene.Children().length < 1 ) { 
				return null; // End of chapter; should go to new chapter
			} // if
			
			// Step 2: Setting up the selection
			var selection = 0;
			if ( choice != null ) { 
				selection = choice;
			} // if
			
			// Step 3: Fetching the next scene
			this.scenes.get( this.active_scene.Data() + "" ).Hide();
			this.active_scene = this.active_scene.Children()[selection];
			this.shown_scene = this.active_scene;
			var scene = this.scenes.get(this.active_scene.Data() + "");
			scene.Show();
			this.past_history.push( this.active_scene );
			
			// Step 3.5 Managing edit mode
			scene.Edit(this.edit_flag);
			
			// Step 4: Prepare forks
			this.p_prepareforks();
		}  // else
		
		return;
	} // Next
	
	// Goes to the previous scene (no choices here)
	public function Previous() : Void {	
		// Step 1: Null check
		if ( this.past_history.last() == this.past_history.first() ) { 
			return null;
		} // if
		
		// Step 2: Managing history
		this.future_history.push(this.past_history.pop());
		this.selector.Hide();
		
		// Step 3: Going back
		this.scenes.get( this.shown_scene.Data() + "" ).Hide();
		this.shown_scene = this.past_history.first();
		var scene = this.scenes.get( this.shown_scene.Data() + "" );
		scene.Show();
		this.p_prepareforks();
		
		// Step 3.5:
		scene.Edit(this.edit_flag);
			
		return;
	} // Previous
	
	/****
	* Public Override Section
	***/
	public override function Hide( ?cb : Void -> Void ) { 
		super.Hide(cb);
		for( scene in this.scenes ) { 
			scene.Hide();
		} // for 
		this.tabs.Hide();
		 // this.loading.Hide();
		 for( u in this.ui ) { 
			u.Hide();
		} // for
		this.loading.Hide();
	} // Hide
	
	public override function Show( ?cb : Void -> Void ) { 
		super.Show(cb);
		this.scenes.get( this.shown_scene.Data() + "" ).Show();
		for( u in this.ui ) { 
			u.Show();
		} // for
		this.p_edittools();
	} // Show
	
	/****
	* Private Operations Section
	***/
	// Loads the active_scene's choices and displays them
	private function p_prepareforks() { 
		// Step 1: Prepare the forks
		var transitions = [];
		for( child in this.active_scene.Children() ) { 
			transitions.push( this.forks.get( this.active_scene.Data() + "-" + child.Data() ) );
		} // for
		this.active_forks = transitions;
		
		// Step 2: Loading into the vbar
		this.selector.Purge();
		
		if ( this.active_forks.length > 1 && this.shown_scene == this.active_scene ) { 
			this.selector.Show();
			for( fork in this.active_forks) { 
				this.selector.Text(fork.Text(), (function(f : Fork) { 
					return function() { 
						this.Next(f.Choice());
					}; // return
				} )(fork)); // Text callback
			} // for
			this.ui.get("next").Hide();
		} // if length < 2
		else { 
			this.ui.get("next").Show();
		} // else
	} // p_loadchoice
	
	private function p_setupui() { 
		// Step 0: Standard setup
		for( k in ['next', 'previous', 'fork', 'edit', 'commit'] ) { 
			var btn = new Tile();
			btn.ClassName("visualnovel-ui btn-" + k);
			btn.Mouseover(function(e){ 
				this.spotlight.On(btn.Size(), btn.Position());
			} );
			btn.Mouseleave(function(e){ 
				this.spotlight.Off();
			});
			this.ui.set( k , btn );
		} // for
		
		// Step 1: Next btn
		this.ui.get("next").Click(function(e){
			this.Next();
		}); // Click
		
		// Step 2: prev btn
		this.ui.get("previous").Click(function(e){
			this.Previous();
		}); // Click
		
		// Step 3: fork btn
		this.ui.get("fork").Click(function(e){ 
			InputControl.Input(function(userinput){
				this.Fork(userinput, function(scene) { 
					return;
				} ); // Fork callback 
			}); // Input callback
		} ); // Click
		
		// Step 4: edit btn
		this.ui.get("edit").Click(function(e){ 
			this.Edit();
			if ( this.edit_flag ) 
				this.ui.get("commit").Show();
			else
				this.ui.get("commit").Hide();
		} ); // Click
		
		// Step 5: commit button
		this.ui.get("commit").Click(function(e){ 
			this.Commit();
		}); // Click
		
		// Step 3: Set styles
		for( u in this.ui ) { 
			u.Hide();
		} // for
	} // p_setupui
	
	private function p_edittools( ) { 
		if( this.edit_flag ) { 
			this.tabs.Show();
			this.ui.get("commit").Show();	
		} // if edit
		else { 
			this.tabs.Hide();
			this.ui.get("commit").Hide();
		} // else
	} // p_edittools
} // VisualNovel