package controls;
import buildingblocks.Tile;
import js.JQuery;
import tools.Random;

// For simplicity reasons, we will support static usage of this class
class InputControl extends Tile {
	/****
	* Static members
	**/
	public static var NAME = "FFOpenVN-InputControl-" + Random.Get(20000);
	public static var ID = 0; 
	
	// Returns the input element
	public static function Input( cb : String -> Void, ?placeholder : String ) : Void{ 
		var container = new Tile();
		container.ClassName("static-input-container");
		var i = "<input type=\"text\" id=\"" + InputControl.NAME + InputControl.ID + "-input\" class=\"static-input-control\" placeholder='" + placeholder + "'/>";
		var s = "<input type=\"submit\" value=\"submit\" id=\""+ InputControl.NAME + InputControl.ID +"-submit\" class=\"static-input-button\" />";
		container.HTML(s+i);
		var i_jq = new JQuery( "#" + InputControl.NAME + InputControl.ID + "-input" );
		var s_jq = new JQuery( "#" + InputControl.NAME + InputControl.ID + "-submit" );
		
		s_jq.click(function(e){ 
			cb( i_jq.val() );
			
			container.Hide();
			container.HTML("");
			container.Remove();
		}); // submit callback
	} // Input
} // InputControl