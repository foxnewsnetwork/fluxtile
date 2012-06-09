package tests;
import animation.BoxHighlighter;

class BoxHighlighterTest {
	public static function main() { 
		var highlight = new BoxHighlighter();
		highlight.Size({ width : 300.0, height : 200.0 });
		highlight.Position({ x : 75.0, y : 89.0 });
		highlight.Show();
	} // main
} // BoxHighlighterTest