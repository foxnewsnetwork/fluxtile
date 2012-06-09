package controls;
import buildingblocks.Tile;

class TextControl extends Tile {
	// text
	private var text : String;
	private var backlight : Tile;
	
	// public functions
	public function Text( ?txt : String ) : String { 
		if ( txt != null ) { 
			this.text = txt;
			this.HTML("<p class=\"textcontrol\">" + this.text + "</p>");
		} // if
		return this.text;
	} // Text
	
	public function new() : Void { 
		this.text = "";
		this.backlight = new Tile();
		this.backlight.CSS("background-color", "rgb(250,250,250)");
		this.backlight.CSS("opacity", "0.85");
		super();
	} // new
	
	// public overrides
	public override function Size( ?siz : { width : Float, height : Float } ) : { width : Float, height : Float } { 
		super.Size(siz);
		return this.backlight.Size(siz);
	} // Size
	
	public override function Position( ? pos : { x : Float, y : Float } ) : { x : Float, y : Float } { 
		super.Position(pos);
		return this.backlight.Position(pos);
	} // Position
} // TextControl