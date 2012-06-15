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
	private var tiles : Array<Tile>;
	private var edit_flag : Bool;
	
	/****
	* Public methods
	***/
	public function new() { 
		super();
		this.text = new TextControl();
		this.text.ClassName("scene-text textbox");
		this.tiles = [];
		this.edit_flag = false;
	} // new
	
	public function AddTile( img : String, ?pos : { x : Float, y : Float } ) { 
		var t = new Tile();
		t.Image(img);
		var location = pos != null ? pos : { x : 25.0, y : 25.0 };
		t.Position(location);
		t.Mode(1);
		this.tiles.push(t);
		t.Show();
	} // AddTile
	
	public function RemoveTile(tile : Tile) { 
		if (this.tiles.remove(tile))
			tile.Hide();
		else
			throw "Tile remove problem";
	} // RemoveTile
	
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
			id : -1 ,
			parent_id : -1 ,
			fork_text : "" ,
			fork_image : "" ,
			fork_number : -1 ,
			children_id : []
		} // state
		
		for( t in this.tiles ) { 
			state.layers.push({
				image : t.Image() ,
				width : t.Size().width ,
				height : t.Size().height ,
				x : t.Position().x ,
				y : t.Position().y
			}) ; // layers.push
		} // for
		return state;	
	} // GetState
	
	// Toggles between edit and normal mode
	public function Edit(?flag : Bool) { 
		this.edit_flag = flag != null ? flag : !this.edit_flag;
		
		if( this.edit_flag ) { 
			for( k in 0...this.tiles.length ) { 
				this.tiles[k].Mode(1);
			} // 
		} // if edit mode
		else { 
			for( k in 0...this.tiles.length ) { 
				this.tiles[k].Mode(0);
			} // 
		} // else
		this.text.Edit(this.edit_flag);
	} // Edit
	
	public function Load( data : SceneData ) : Void {
		// Step 1: Load the text
		this.text.Hide();
		this.text.Text(data.text);
		
		// Step 2: Load the tiles
		this.tiles = [];
		for( k in 0...data.layers.length ) {
			this.tiles.push(new Tile());
			this.tiles[k].Hide();
			this.tiles[k].Image(data.layers[k].image);
			this.tiles[k].Position({ x : data.layers[k].x, y : data.layers[k].y});
			this.tiles[k].Size({ width : data.layers[k].width, height : data.layers[k].height});
		} // for
	} // Load
	
	/****
	* Override methods
	***/
	public override function Show(?cb : Void -> Void) : Void {
		super.Show(cb);
		for( k in 0...this.tiles.length ){ 
			this.tiles[k].Show();
		} // for
		this.text.Show();
	} // Show
	
	public override function Hide(?cb : Void -> Void) : Void {
		super.Hide(cb);
		for( k in 0...this.tiles.length ){ 
			this.tiles[k].Hide();
		} // for
		this.text.Hide();
	} // Show
} // Scene