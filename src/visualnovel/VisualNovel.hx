package visualnovel;
import toolbar.HorizontalBar;
import buildingblocks.Tile;
import controls.IconsControl;
import controls.TextControl;
import datastructures.Tree;
import animation.Spotlight;

class VisualNovel extends Tile {
	/****
	* Private member variables
	***/
	private var scenes : Hash<Scene>; // all loaded scenes
	private var scene_tree : TreeNode<Int>; // tree root 
	private var active_scene : TreeNode<Int>; // Scene we're currently on
	private var scene_history : Array<TreeNode<Int>>; // history of the scenes we've visited
	private var loading : Tile; // Now-Loading animation
	private var tabs : HorizontalBar; // Control bar
	private var ui : Hash<Tile>; // buttons, clickers, etc.
	private var permission : Hash<Int>; // permission levels
	private var spotlight : Spotlight; // used to highlight stuff
	
	/****
	* Public methods
	***/
	public function new() { 
		// Step 1: New junk
		super();
		this.scenes = new Hash<Scene>();
		this.tabs = new HorizontalBar();
		this.ui = new Hash<Tile>();
		this.permission = new Hash<Int>();
		this.scene_history = [];
		this.loading = new Tile();
		this.spotlight = new Spotlight();
		
		// Step 2: Set UI
		this.loading.Show();
		this.loading.HTML("<h4 class=\"now-loading\">Now Loading...</h4>");
		this.loading.ClassName("visualnovel-placeholder now-loading");
		this.tabs.ClassName("visualnovel-ui tabs-holder");
		var btn = new Tile();
		btn.ClassName("visualnovel-ui btn-next");
		btn.Click(function(e){
			this.Next();
		}); // Click
		btn.Mouseover(function(e){ 
			this.spotlight.On(btn.Size(), btn.Position());
		} );
		btn.Mouseleave(function(e){ 
			this.spotlight.Off();
		});
		this.ui.set("next", btn );
		
		var btn2 = new Tile();
		btn2.ClassName("visualnovel-ui btn-previous");
		btn2.Click(function(e){
			this.Previous();
		}); // Click
		btn2.Mouseover(function(e){ 
			this.spotlight.On(btn2.Size(), btn2.Position());
		} );
		btn2.Mouseleave(function(e){ 
			this.spotlight.Off();
		});
		this.ui.set("previous", btn2 );
		
		// Step 3: Set styles
		for( u in this.ui ) { 
			u.Hide();
		} // for
	} // new
	
	// Starts off the visual novel at the root scene
	public function Start() : Scene { 
		// Step 1: Navigate to the root scene
		this.active_scene = this.scene_tree;
		this.scene_history = [];
		
		// Step 2: Hide EVERYTHING
		this.Hide();
		
		// Step 3: Show everything again
		this.Show(); 
			
		// Step 4: Fish out the scene in question
		return this.scenes.get(this.active_scene.Data() + "");
		this.loading.Hide();
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
		
		// Step 1.5: Tracing a bit
		this.active_scene = this.scene_tree;
		
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
	
	// Creates a new scene and attaches it wherever we are
	//                                / - (s4 a)        
	// (s1) - (s2) - (s3) (forked here) - (s4) - (s5) (forked here) - (s6)
	//                                                           \ - (s6 a)
	// New scenes should only be initialized when we get an ID from the server
	public function Fork(id : Int) : Scene { 
		var scene = new Scene();
		var scenedata = { 
			layers : [],
			text : "",
			id : id ,
			parent_id : this.active_scene.Data() ,
			children_id : []
		}; // scenedata
		this.active_scene.Branch(id);
		scene.Load(scenedata);
		this.scenes.set(id + "", scene);
		return scene;
	} // NewScene
	
	// Goes to the next scene ( defaults to first path )
	public function Next( ?choice : Int ) : Scene { 
		if ( this.active_scene.Children().length < 1 ) { 
			return null;
		} // if
		var selection = 0;
		if ( choice != null ) { 
			selection = choice;
		} // if
		this.scene_history.push( this.active_scene );
		this.scenes.get( this.active_scene.Data() + "" ).Hide();
		this.active_scene = this.active_scene.Children()[selection];
		var scene = this.scenes.get(this.active_scene.Data() + "");
		scene.Show();
		return scene;
	} // Next
	
	// Goes to the previous scene (no choices here)
	public function Previous() : Scene {
		if ( this.scene_history.length < 1 ) { 
			return null;
		} // if
		this.scenes.get( this.active_scene.Data() + "" ).Hide(); 
		this.active_scene = this.scene_history.pop();
		var scene = this.scenes.get( this.active_scene.Data() + "" );
		scene.Show();
		return scene;
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
		this.scenes.get( this.active_scene.Data() + "" ).Show();
		this.tabs.Show();
		for( u in this.ui ) { 
			u.Show();
		} // for
	} // Show
} // VisualNovel