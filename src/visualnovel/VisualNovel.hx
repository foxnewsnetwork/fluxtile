package visualnovel;
import toolbar.HorizontalBar;
import buildingblocks.Tile;
import controls.IconsControl;
import controls.TextControl;
import datastructures.Tree;

class VisualNovel extends Tile {
	/****
	* Private member variables
	***/
	private var scenes : Hash<Scene>; // all loaded scenes
	private var scene_tree : TreeNode<Int>; // tree root 
	private var active_scene : TreeNode<Int>; // Scene we're currently on
	private var loading : Tile; // Now-Loading animation
	private var tabs : HorizontalBar; // Control bar
	
	/****
	* Public methods
	***/
	public function new() { 
		// Step 1: New junk
		super();
		this.scenes = new Hash<Scene>();
		this.tabs = new HorizontalBar();
		
		// Step 2: Set styles
	} // new
	
	// Starts off the visual novel at the root scene
	public function Start() : Scene { 
		// Step 1: Navigate to the root scene
		this.active_scene = this.scene_tree;
		
		// Step 2: Hide EVERYTHING
		this.Hide();
		
		// Step 3: Show everything again
		this.Show(); 
			
		// Step 4: Fish out the scene in question
		return this.scenes.get(this.active_scene.Data() + "");
	} // Start
	
	public function Load( data : Array<SceneData> ): Void { 
		// Step 1: Load up scenes
		this.scenes = new Hash<Scene>();
		this.scene_tree = null;
		for( k in 0...data.length ) {
			var scene = new Scene();
			scene.Load(data[k]);
			this.scenes.set(data[k].id + "", scene );
			if ( data[k].parent_id == null ) { 
				this.scene_tree = Tree.Create(data[k].id);
			} // if
			scene.Hide();
		} // for
		this.active_scene = this.scene_tree;
		
		// Step 2: Error-handling
		if ( this.scene_tree == null ) { 
			throw "Bad scene data - attempted cirrcular tree depedence. Seriously, please don't write trees that are their own parents";
		} // if
		
		// Step 3: Loading scene_tree data
		var leafs : Array<TreeNode<Int>> = [this.scene_tree];
		while((function(nodes : Array<TreeNode<Int>>) {
			var flag = false; 
			for( k in 0...nodes.length ) { 
				if( nodes[k].Children().length > 0 ) { 
					flag = true;
					break;
				} // if
			} // for
			return flag;
		})(leafs)) { // while lambda
			var children = [];
			for( k in 0...leafs.length ) { 
				var leaf = leafs[k];
				for( j in 0...data.length ) { 
					if( data[j].id == leaf.Data() ) { 
						for( h in 0...data[j].children_id.length ) { 
							children.push(leaf.Branch( data[j].children_id[h] ));
						} // for h
					} // if
				} // for j
			} // for k
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
		var selection = 0;
		if ( choice != null ) { 
			selection = choice;
		} // if
		this.scenes.get( this.active_scene.Data() + "" ).Hide();
		this.active_scene = this.active_scene.Children()[selection];
		var next_id = this.active_scene.Data();
		var scene = this.scenes.get(next_id + "");
		scene.Show();
		return scene;
	} // Next
	
	// Goes to the previous scene (no choices here)
	public function Previous() : Scene {
		this.scenes.get( this.active_scene.Data() + "" ).Hide(); 
		this.active_scene = this.active_scene.Parent();
		var prev_id = this.active_scene.Data();
		var scene = this.scenes.get( prev_id + "" );
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
	} // Hide
	
	public override function Show( ?cb : Void -> Void ) { 
		super.Show(cb);
		this.scenes.get( this.active_scene.Data() + "" ).Show();
		this.tabs.Show();
	} // Show
} // VisualNovel