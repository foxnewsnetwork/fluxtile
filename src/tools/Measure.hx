package tools;
import js.JQuery;

// Static class for measurement
class Measure {
	public static var NAME = "FFOpenVN-MeasureTool-" + Random.Get(999999);
	public static function ImageSize( img : String ) : { width : Float, height : Float } { 
		var output = "<img alt='gettingsize' src='" + img + "' id='" + Measure.NAME + "' style='position : absolute;' />";
		(new JQuery("body")).append(output);
		var jq = new JQuery("#" + Measure.NAME);
		var size = { width : jq.width() + 0.0, height : jq.height() + 0.0 };
		jq.replaceWith("");
		return size;
	} // ImageSize
} // Measure