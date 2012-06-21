package visualnovel;
import buildingblocks.Tile;

class Layer extends Tile {
	private var storage : { id : Int, element_id : Int };
	
	public function Storage( ?data : { id : Int, element_id : Int } ) : { id : Int, element_id : Int } {
		if( data != null )
			this.storage = data;
		return this.storage;
	} // Storage
	
	public function Load( data : LayerData ) { 
		this.storage = { id : null, element_id : null };
		this.Image(data.image);
		this.storage.id = data.id;
		this.storage.element_id = data.element_id;
		this.Size({ width : data.width, height : data.height });
		this.Position( { x : data.x, y : data.y });
	} // Load 
	
	public function GetState() : LayerData { 
		return { 
			id : this.Storage().id ,
			image : this.Image() ,
			width : this.Size().width ,
			height : this.Size().height ,
			x : this.Position().x ,
			y : this.Position().y ,
			element_id : this.Storage().element_id
		}; // return
	} // GetState
} // Layer