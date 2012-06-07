package toolbar;
import buildingblocks.Tile;

class HorizontalBar extends Tile {
	/***
	* Private Members Section
	**/
	// These things:
	// ---------------------------
	// - btn 1 -- btn 2 -- btn 3 -
	// ---------------------------
	private var icons : Array<Tile>;
	// Indictates the active tab
	// ---------------------------
	// - btn 1 -| BTN 2 |- btn 3 -
	// ---------------------------
	private var active : Int;
	
	/***
	* Public Function Section
	**/
	// Constructor
	public function new() { 
		super();
		this.icons = [];
		this.active = 0;
	} // new
	
	// Returns the icons or pushes onto a new one from an image
	// Once an icon is pushed on, it's hard to take off
	public function Icons( ?img : String, ?cb : Void -> Void ) : Void { 
		if ( img == null ) { 
			// NOTHING
		} // if
		else { 
			// Step 1: Setting up the icon
			var icon = new Tile();
			icon.Image(img);
			
			// Step 2: Configuring size
			var iwidth = this.Size().width / this.icons.length;
			var iheight = this.Size().height;
			icon.Size({ width : iwidth, height : iheight });
			
			// Step 3: Configuring position
			var ix = this.icons.length * iwidth + this.Position().x;
			var iy = this.Position().y;
			icon.Position({x : ix, ; : iy });
			
			// Step 4: Setup click
			var n = this.icons.length;
			icon.Click( function( e ) { 
				this.icons[this.active].CSS( "border", "none" );
				this.active = n;
				icon.CSS( "border", "4px solid red" ); // Temporary
				if ( cb != null ) 
					cb();
			} ); // Icon.Click
			
			// Step 5: Setup mouseover
			// TODO: Write me!
			
			// Step 6: Setup mouseleave
			// TODO: Write me!
		} // else
	} // Icon
	
	/***
	* Override Public Function Section
	**/
	public override function Size( ?siz : { width : Float, height : Float }, ?type : String ) : { width : Float, height : Float } { 
		if ( siz == null ) { 
			return super.Size();
		} // if
		else { 
			var size = super.Size( siz, type );
			var iwidth = size.width / this.icons.length;
			var iheight = size.height; 
			for ( k in 0...this.icons.length ) { 
				this.icons[k].Size({ width : iwidth, height : iheight });
				this.icons[k].Position({ x : k * iwidth + this.Position().x, y : this.Position().y });
			} // for
			return size;
		} // else
	} // Size
	public override function Position( ?pos : { x : Float, y : Float }, ?type : String ) : { x : Float, y : Float } { 
		if ( pos == null ) { 
			return super.Position();
		} // if
		else { 
			var position = super.Position( pos, type );
			var iwidth = this.Size().width / this.icons.length;
			for( k in 0...this.icons.length ) { 
				this.icons[k].Position({ x : k * width + position.x, y : position.y });
			} // for
			return position;
		} // else
	} // Position
} // HorizontalBar