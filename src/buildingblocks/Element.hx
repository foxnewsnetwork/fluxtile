package buildingblocks;
import js.JQuery;

class Element {
	public static var ID : Int = 0;
	public static var NAME : String = "FFOpenVN-Tile-Element-" + Math.floor(10000 * Math.random()); 
	private var domContainer : JQuery;
	private var domBody : JQuery;
	private var position : { x : Float, y : Float };
	private var type_position : String;
	private var size : { width : Float, height : Float };
	private var type_size : String;
	private var hides : Array<Void -> Void>;
	private var shows : Array<Void -> Void>;
	private var parent : JQuery; // defaults to body
	private var timer : haxe.Timer;
	private var bgcolor : String;
	private var class_name : String; // html dom class for styling purposes
	
	public static var TestCounter : Int = 0;
	
	public function ClassName( ?cn : String ) { 
		if ( cn != null ) {
			this.domContainer.removeClass(this.class_name).addClass( cn );
			this.class_name = cn;
		} // if
		return this.class_name;
	} // ClassName
	
	public function new(){
		this.hides = [];
		this.shows = []; 
		this.position = { x : 0.0, y : 0.0 };
		this.size = { width : 75.0, height : 75.0 };
		this.domBody = new JQuery( "body" );
		this.parent = domBody;
		domBody.append("<div id='" + Element.NAME + "-" + Element.ID + "'></div>");
		this.domContainer = new JQuery( "#" + Element.NAME + "-" + Element.ID );
		Element.ID += 1;
		this.CSS("z-index", "967");
		this.CSS("position", "absolute");
		this.type_position = "px";
		this.type_size = "px";
	} // end new
	
	// Set the position type
	public function TypePosition( ?type : String ) : String { 
		if ( type != null ) { 
			this.type_position = type;
		} // if
		return this.type_position;
	} // TypePosition
	
	// Position is always with respect to the parent
	public function Position( ?pos : { x : Float, y : Float } ) : { x : Float, y : Float }{ 
		Element.TestCounter++;
		if( pos == null ){ 
			return this.position;
		} //end if
		this.position = pos;
		var x = this.position.x;
		var y = this.position.y;
		this.domContainer.css("left", x + this.type_position );
		this.domContainer.css("top", y + this.type_position );
		return this.position;
	} // end Position
	
	// Set the size type
	public function TypeSize( ?type : String ) : String { 
		if ( type != null ) { 
			this.type_size = type;
		} // if
		return this.type_size;
	} // TypeSize
	
	public function Size( ?siz : { width : Float, height : Float } ) : { width : Float, height : Float }{ 
		if( siz == null ){ 
			return this.size;
		} // end if
		this.size = siz;
		this.domContainer.css("width", this.size.width + this.type_size );
		this.domContainer.css("height", this.size.height + this.type_size );
		this.domContainer.css("background-size", "100% 100%");
		return this.size;
	} // end Size
	
	public function Remove() : Void{
		this.Hide();
		this.domContainer.remove();
	}// end remove
	
	public function Hide(?cb : Void -> Void) : Void{ 
		if(cb == null){ 
			this.domContainer.hide(25, (function(element : Element){
				return function(){
					for(k in 0...element.hides.length){
						element.hides[k]();
					} //end for
				}; // end return
			})(this)); // end hide
		} //end if
		else{
			this.hides.push(cb);
		} // end else
	} //end Hide
	
	public function Show(?cb : Void -> Void) : Void{ 
		if(cb == null){ 
			this.domContainer.show(25,(function(element : Element){
				return function(){
					for(k in 0...element.shows.length){
						element.shows[k]();
					} //end for
				}; // end return
			})(this)); // end show
		} //end if
		else{
			this.shows.push(cb);
		} // end else
	} //end show
	
	public function CSS( prop : String, value : String ) : Void{ 
		this.domContainer.css( prop, value );
		if( prop == "background-color" ){ 
			this.bgcolor = value;
		} // end if
	} // end CSS
	
	public function HTML( ?html : String ) : String{ 
		if( html == null ){ 
			return this.domContainer.html();
		}//end if
		this.domContainer.html(html);
		return html;
		
	} // end HTML
}