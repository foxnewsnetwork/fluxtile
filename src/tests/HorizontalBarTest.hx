package tests;
import toolbar.HorizontalBar;

class HorizontalBarTest {
	public static function main() : Void { 
		var hbar = new HorizontalBar();
		var icons = [ "madotsuki.png", "madotsuki.png", "madotsuki.png" ];
		
		for( k in 0...icons.length )
			hbar.Icon(icons[k]);
		hbar.Size({ width : 400.0, height : 75.0 });
		hbar.Position({x : 0.0, y : 0.0});
		hbar.Show();
	} // main
} // HorizontalBarTest