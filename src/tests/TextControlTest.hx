package tests;
import controls.TextControl;

class TextControlTest {
	public static function main() { 
		var text = new TextControl();
		text.Text("You are a faggot!");
		text.Size({ width : 450.0, height : 300.0 });
		text.Position({ x : 50.0, y : 75.0 });
		text.CSS("border", "3px solid red");	
		text.Show();
		text.Mouseover(function(e) { 
			text.CSS("border", "1px solid blue");
		} ); // Mouseover
		text.Mouseleave(function(e){ 
			text.CSS("border", "2px solid red" );
		} );
		text.Click(function(e){ 
			text.CSS("border", "2px solid black" );
		} );
	} // main
} // TextControlTest