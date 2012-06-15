package tools;
import js.JQuery;
import buildingblocks.Tile;

// Requires the external class tooltip
class Tooltip {
	public static var HaxeToolTip : Tile = new Tile();
	public static var ID : Int = 0;

	public static function Show( html : String ) : Void { 
		var t : Tile = Tooltip.HaxeToolTip;
		t.Show();
		if ( Tooltip.ID > 0 ) { 
			t.HTML(html);
		} // if
		else { 
			t.ClassName("haxetooltip");
			t.HTML(html);
			t.CSS("z-index", "9999");
			(new JQuery("body")).mousemove(function(e){ 
				var posX = e.pageX + 15.0;
				var posY = e.pageY + 20.0; 
				t.Position({ x : posX, y : posY });
			}); // body mousemove
			Tooltip.ID += 1;
		} // else
	} // Show
	
	public static function Hide() : Void { 
		Tooltip.HaxeToolTip.Hide();
	} // Hide
} // Tooltip