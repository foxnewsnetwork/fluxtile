package tests;
import controls.IconsControl;

class IconsControlTest {
	public static function main() { 
		var ic = new IconsControl();
		for( k in 0...48 ) { 
			ic.AddIcon("madotsuki.png", function(){ js.Lib.alert("Madotsuki"); });
		} // for
		ic.CSS("border", "1px solid blue");
		ic.Show();
	} // main
} // IconsControlTest