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
	
	/****
	* Public methods
	***/
	public function new() { 
		super();
		this.text = new TextControl();
		this.text.TypePosition("%");
		this.text.Position({ x : 0.5, y : 60.0 });
		this.text.TypeSize("%");
		this.text.Size({width : 99.5 , height : 40.0 });
		this.tiles = [];
	} // new
	
	public function Load( data : SceneData ) : Void {
		// Step 1: Load the text
		this.text.Text(data.text);
		
		// Step 2: Load the tiles
		this.tiles = [];
		for( k in 0...data.layers.length ) {
			this.tiles.push(new Tile());
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