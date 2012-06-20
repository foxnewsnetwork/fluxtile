package visualnovel;
import controls.IconsControl;
import controls.TextControl;
import buildingblocks.Tile;
import toolbar.HorizontalBar;

class Scene extends Tile {
	/****
	* Private members
	***/
	private var text : TextControl;
	private var layers : Array<Layer>;
	private var edit_flag : Bool;
	
	private var storage : { id : Int, owner_id : Int, parent_id : Int };
	
	/****
	* Public methods
	***/
	public function new() { 
		super();
		this.text = new TextControl();
		this.text.ClassName("scene-text textbox");
		this.layers = [];
		this.edit_flag = false;
	} // new
	
	public function AddLayer( data : LayerData ) { 
		var layer = new Layer();
		layer.Load(data);
		layer.Mode(1);
		this.layers.push(layer);
		layer.Show();
	} // AddLayer
	
	public function RemoveLayer(layer : Layer) { 
		if (this.layers.remove(layer))
			layer.Hide();
		else
			throw "Tile remove problem";
	} // RemoveLayer
	
	public function ShowText(flag : Bool) { 
		if( flag )
			this.text.Show();
		else
			this.text.Hide();
	} // HideText
	
	// Returns information on everything in a scene
	public function GetState() : SceneData { 
		var state : SceneData = { 
			layers : [] ,
			text : this.text.GetState() ,
			id : this.storage.id ,
			parent_id : this.storage.parent_id ,
			owner_id : this.storage.owner_id ,
			fork_text : "" ,
			fork_image : "" ,
			fork_number : -1 ,
			children_id : []
		} // state
		
		for( layer in this.layers ) { 
			state.layers.push( layer.GetState() );
		} // for
		return state;	
	} // GetState
	
	// Toggles between edit and normal mode
	public function Edit(?flag : Bool) { 
		this.edit_flag = flag != null ? flag : !this.edit_flag;
		
		if( this.edit_flag ) { 
			for( layer in this.layers )
				layer.Mode(1); 
		} // if edit mode
		else { 
			for( layer in this.layers )
				layer.Mode(0);
		} // else
		this.text.Edit(this.edit_flag);
	} // Edit
	
	public function Load( data : SceneData ) : Void {
		// Step 1: Load the text
		this.text.Hide();
		this.text.Text(data.text);
		
		// Step 2: Load the tiles
		this.layers = [];
		for( layerdata in data.layers ) { 
			var layer = new Layer();
			layer.Load(layerdata);
			this.layers.push(layer);
		} // for
	} // Load
	
	/****
	* Override methods
	***/
	public override function Show(?cb : Void -> Void) : Void {
		super.Show(cb);
		for( k in 0...this.layers.length ){ 
			this.layers[k].Show();
		} // for
		this.text.Show();
	} // Show
	
	public override function Hide(?cb : Void -> Void) : Void {
		super.Hide(cb);
		for( k in 0...this.layers.length ){ 
			this.layers[k].Hide();
		} // for
		this.text.Hide();
	} // Show
} // Scene