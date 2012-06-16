package animation;
import buildingblocks.Tile;

// Highlights only the edges
class BoxHighlighter {
	private var edges : Array<Tile>;
	private var position : { x : Float, y : Float };
	private var size : { width : Float, height : Float };
	
	public function new() { 
		this.edges = [];
		this.position = { x : 0.0, y : 0.0 };
		this.size = { width : 0.0, height : 0.0 } ;
		for( k in 0...2 ) {
			for( j in 0...2 ) { 
				this.edges.push( new Tile() );
				this.edges[2*k + j].CSS( "background-color", "rgb(185,200,200)" );
				this.edges[2*k + j].CSS( "border", "1px solid yellow" );
				this.edges[2*k + j].CSS( "z-index", "9990" );
			} // for j
		} // for k
	} // new
	
	// Only pixel support for now
	public function Position(?pos : { x : Float, y : Float } ) : { x : Float, y : Float } { 
		if ( pos != null ) { 
			this.position = pos;
			this.edges[0].Position(pos);
			this.edges[1].Position(pos);
			this.edges[2].Position({ x : pos.x + this.Size().width , y : pos.y });
			this.edges[3].Position({ x : pos.x, y : pos.y + this.Size().height });
		} // if
		return this.position;
	} // Position
	
	// Only pixel support for now
	public function Size( ? siz : { width : Float, height : Float } ) : { width : Float, height : Float } { 
		if ( siz != null ) { 
			this.size = siz;
			this.edges[0].Size({ width : 1.0, height : siz.height });
			this.edges[1].Size({width : siz.width, height : 1.0 });
			this.edges[2].Size({ width : 1.0, height : siz.height });
			this.edges[2].Position({ x : this.Position().x + siz.width, y : this.Position().y });
			this.edges[3].Size({ width : siz.width, height : 1.0 });
			this.edges[3].Position({ x : this.Position().x, y : this.Position().y + siz.height });
		} // if
		return this.size;
	} // Size
	
	public function Show() : Void { 
		for ( k in 0...this.edges.length ) { 
			this.edges[k].Show();
		} // for
	} // Show
	
	public function Hide() : Void { 
		for ( k in 0...this.edges.length ) { 
			this.edges[k].Hide();
		} // for
	} // Hide
} // BoxHighlighter