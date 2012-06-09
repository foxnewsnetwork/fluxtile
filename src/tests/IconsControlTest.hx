package tests;
import controls.IconsControl;

class IconsControlTest {
	public static function main() { 
		var ic = new IconsControl();
		for( k in 0...45 ) { 
			ic.AddIcon("madotsuki.png", function(){ js.Lib.alert("Madotsuki"); });
		} // for
		ic.Size({ width : 550.0, height : 300.0 });
		ic.Position({ x : 0.0, y : 150.0 });
		ic.CSS("border", "1px solid blue");
		ic.Show();
	} // main
} // IconsControlTest