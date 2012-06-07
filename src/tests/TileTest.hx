package tests;
import buildingblocks.Tile;

class TileTest {
	public static function main() : Void { 
		// Before each
		var tile = new Tile();
		var edit_tile = new Tile();
		
		tile.Size({width : 100.0, height : 100.0});
		tile.Position({x : 75.0, y : 75.0 });
		tile.Image("madotsuki.png");
		tile.Show();
		
		edit_tile.Size({ width : 150.0, height : 150.0 });
		edit_tile.Position( { x : 275.0, y : 275.0 } );
		edit_tile.Image("madotsuki.png");
		edit_tile.Mode(1);
		edit_tile.Show();
	} // main
} // TileTest