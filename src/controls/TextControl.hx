package controls;
import buildingblocks.Tile;
import js.JQuery;

class TextControl extends Tile {
	// Static
	public static var ID = 0;
	
	// text
	private var text : String;
	private var backlight : Tile;
	private var edit_flag : Bool;
	private var textarea : JQuery;
	
	// public functions
	public function Text( ?txt : String ) : String { 
		if ( txt != null ) { 
			this.text = txt;
			this.HTML("<p class=\"textcontrol\">" + this.text + "</p>");
		} // if
		return this.text;
	} // Text
	
	public function new() : Void { 
		TextControl.ID += 1;
		this.text = "";
		this.backlight = new Tile();
		this.backlight.CSS("background-color", "rgb(250,250,250)");
		this.backlight.CSS("opacity", "0.85");
		this.edit_flag = false;
		super();
	} // new
	
	// Gets the state; in this case, the words typed in the textarea
	public function GetState() { 
		return this.textarea.val();
	} // Save
	
	public function Edit() { 
		this.edit_flag = !this.edit_flag;
		
		if( this.edit_flag ) { 
			var txta = "<textarea rows='8' cols='90' class='textcontrol-edit' id='textcontrol-" + TextControl.ID + "'>";
			txta += this.text;
			txta += "</textarea>"; 
			this.HTML(txta);
			this.textarea = new JQuery("#" + "textcontrol" + TextControl.ID );
		} // if edit
		else { 
			this.HTML("<p class=\"textcontrol\">" + this.text + "</p>");
		} // else
	} // Edit
	
	// public overrides
	public override function Size( ?siz : { width : Float, height : Float } ) : { width : Float, height : Float } { 
		super.Size(siz);
		return this.backlight.Size(siz);
	} // Size
	
	public override function Position( ? pos : { x : Float, y : Float } ) : { x : Float, y : Float } { 
		super.Position(pos);
		return this.backlight.Position(pos);
	} // Position
	
	public override function Hide( ?cb : Void -> Void ) { 
		super.Hide(cb);
		this.backlight.Hide();
	} // Hide
	
	public override function Show(?cb : Void -> Void) { 
		super.Show(cb);
		this.backlight.Show();
	} // Show
} // TextControl