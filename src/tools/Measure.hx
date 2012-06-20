package tools;
import buildingblocks.Tile;

// Static class for measurement
class Measure {
	public static function ImageSize( img : String ) : { width : Float, height : Float } { 
		var tile = new Tile();
		tile.Image(img);
		var size = tile.Size();
		tile.Hide();
		tile.Remove();
		return size;
	} // ImageSize
} // Measure