package toolbar;
import buildingblocks.Tile;
import animation.BoxHighlighter;

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
	// Highlighter
	private var highlight : BoxHighlighter; 
	
	/***
	* Public Function Section
	**/
	// Constructor
	public function new() { 
		super();
		this.icons = [];
		this.active = 0;
		this.highlight = new BoxHighlighter();
		this.highlight.Hide();
	} // new
	
	// Returns the icons or pushes onto a new one from an image
	// Once an icon is pushed on, it's hard to take off
	public function Icon( img : String, ?cb : Void -> Void ) : Void { 
		if ( img == null ) { 
			// NOTHING
		} // if
		else { 
			// Step 1: Setting up the icon
			var icon = new Tile();
			icon.ClassName("horizontal-bar-icon icon" + this.icons.length);
			icon.Image(img);
			
			// Step 2: Configuring size
			var iwidth = this.Size().width / this.icons.length;
			// var iwidth = 75.0;
			var iheight = this.Size().height;
			icon.Size({ width : iwidth, height : iheight });
			
			// Step 3: Configuring position
			var ix = this.icons.length * iwidth + this.Position().x;
			var iy = this.Position().y;
			icon.Position({x : ix, y : iy });
			
			// Step 4: Setup click
			var n = this.icons.length;
			icon.Click( function( e ) { 
				this.icons[this.active].CSS( "border", "none" );
				this.active = n;
				icon.CSS( "border", "2px solid red" ); // Temporary
				if ( cb != null ) 
					cb();
			} ); // Icon.Click
			
			// Step 5: Setup mouseover
			icon.Mouseover(function(e){ 
				this.highlight.Position(icon.Position());
				this.highlight.Size(icon.Size());
				this.highlight.Show();
				// icon.CSS("border", "2px solid yellow");
			}); // icon.Mouseover
			
			// Step 6: Setup mouseleave
			icon.Mouseleave( function(e){
				this.highlight.Hide(); 
				// icon.CSS("border", "none");
			} ); // icon.Mouseleave
			
			// Step 7: Adding to the icon list
			this.icons.push(icon);
		} // else
	} // Icon
	
	/***
	* Override Public Function Section
	**/
	public override function Size( ?siz : { width : Float, height : Float } ) : { width : Float, height : Float } { 
		if ( siz == null ) { 
			return super.Size();
		} // if
		else { 
			super.Size(siz);
			var iwidth = siz.width;
			if ( this.icons.length != 0 ) { 
				iwidth /= this.icons.length; 
			} // if 
			
			var iheight = siz.height;
			this.highlight.Size({ width : iwidth, height : iheight }); 
			for ( k in 0...this.icons.length ) { 
				this.icons[k].Size({ width : iwidth, height : iheight });
				this.icons[k].Position({ x : k * iwidth + this.Position().x, y : this.Position().y });
			} // for
			return siz;
		} // else
	} // Size
	public override function Position( ?pos : { x : Float, y : Float } ) : { x : Float, y : Float } { 
		if ( pos == null ) { 
			return super.Position();
		} // if
		else { 
			super.Position( pos );
			var iwidth = this.Size().width;
			if ( this.icons.length != 0 ) { 
				iwidth /= this.icons.length;
			} // if
			for( k in 0...this.icons.length ) { 
				this.icons[k].Position({ x : k * iwidth + pos.x, y : pos.y });
			} // for
			return pos;
		} // else
	} // Position
	public override function Show( ?cb : Void -> Void ) { 
		super.Show(cb);
		for( k in 0...this.icons.length ) { 
			this.icons[k].Show();
		} // for
	} // Show
	public override function Hide( ?cb : Void -> Void ) { 
		if ( cb == null ) { 
			super.Hide();
		} // if
		else { 
			super.Hide(cb);
		} // else
		for( k in 0...this.icons.length ) { 
			this.icons[k].Hide();
		} // for
	} // Hide
} // HorizontalBar