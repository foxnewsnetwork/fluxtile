package visualnovel;
import controls.IconsControl;
import controls.TextControl;
import buildingblocks.Tile;
import toolbar.HorizontalBar;
import visualnovelevents.LayerDeleteEvent;
import events.EventMachine;

class Scene extends Tile {
	/****
	* Private members
	***/
	private var text : TextControl;
	private var layers : Hash<Layer>;
	private var edit_flag : Bool;
	
	private var storage : { id : Int, owner_id : Int, parent_id : Int };
	
	/****
	* Public methods
	***/
	public function new() { 
		super();
		this.text = new TextControl();
		this.text.ClassName("scene-text textbox");
		this.layers = new Hash<Layer>();
		this.edit_flag = false;
		this.storage = { id : null, owner_id : null, parent_id : null };
	} // new
	
	public function AddLayer( data : LayerData ) { 
		var lay = new Layer();
		lay.Load(data);
		lay.Mode(1);
		lay.Delete(function() { 
			this.RemoveLayer(lay);
		}); // delete callback
		this.layers.set(lay.LayerId(), lay);
		lay.Show();
	} // AddLayer
	
	public function RemoveLayer(layer : Layer) { 
		EventMachine.Fire(new LayerDeleteEvent(layer.Id(), this.Id() ) );
		
		if (this.layers.remove(layer.LayerId())) {
			layer.Hide();
			trace("removed layer");
		} // if 
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
			for( layer in this.layers ) {
				layer.Mode(1);
				layer.CSS("z-index", "9997");
			} // for layer 
		} // if edit mode
		else { 
			for( layer in this.layers ) {
				layer.Mode(0);
				layer.CSS("z-index", "500");
			} // for layer
		} // else
		this.text.Edit(this.edit_flag);
	} // Edit
	
	public function Load( data : SceneData ) : Void {
		// Step 1: Load the text
		this.text.Hide();
		this.text.Text(data.text);
		
		// Step 2: Load the tiles
		this.layers = new Hash<Layer>();
		for( layerdata in data.layers ) { 
			var layer = new Layer();
			layer.Load(layerdata);
			layer.Delete((function(l : Layer){
				return function() {
					trace("almost to deleting"); 
					this.RemoveLayer(l);
				}; // return
			})(layer)); // delete callback
			this.layers.set(layer.LayerId(), layer);
		} // for
		
		// Step 3: Load the miscellanious information
		this.storage.id = data.id;
		this.storage.owner_id = data.owner_id;
		this.storage.parent_id = data.parent_id;
	} // Load
	
	/****
	* Override methods
	***/
	public override function Show(?cb : Void -> Void) : Void {
		super.Show(cb);
		for( key in this.layers.keys() ) { 
			this.layers.get(key).Show();
		} // for
		this.text.Show();
	} // Show
	
	public override function Hide(?cb : Void -> Void) : Void {
		super.Hide(cb);
		for( key in this.layers.keys() ) { 
			this.layers.get(key).Hide();
		} // for
		this.text.Hide();
	} // Show
} // Scene