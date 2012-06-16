package animation;
import js.JQuery;

// Spotlight can highlight only 1 thing at a time
class Spotlight {
	// Static usage
	public static var Lights : BoxHighlighter = new BoxHighlighter();
	
	public static function Shine( size : { width : Float, height : Float }, pos : { x : Float, y : Float } )  {
		Spotlight.Lights.Size(size);
		Spotlight.Lights.Position(pos);
		Spotlight.Lights.Show();
	} // On 
	
	public static function Die() { 
		Spotlight.Lights.Hide();
	} // Off
	
	// Standard usage
	private var highlighter : BoxHighlighter;
	private var mouse : { x : Float, y : Float };
	
	// Shines at the mouse if no position is provided
	public function On( size : { width : Float, height : Float }, ?pos : { x : Float, y : Float } )  {
		this.highlighter.Size(size);
		if ( pos != null ) { 
			this.highlighter.Position(pos);
		} // if
		else { 
			this.highlighter.Position({ x : this.mouse.x - size.width / 2, y : this.mouse.y - size.height / 2 });
		} // else
		this.highlighter.Show();
	} // Shine
	
	public function Off() { 
		this.highlighter.Hide();
	} // Off
	
	public function new() { 
		this.highlighter = new BoxHighlighter();
		this.mouse = { x : 0.0, y : 0.0 };
		(new JQuery("body")).mousemove(function(e){ 
			this.mouse.x = e.pageX + 0.0;
			this.mouse.y = e.pageY + 0.0;
		}); // mousemove
	} // new
} // Spotlight