package toolbar;
import buildingblocks.Tile;
import js.JQuery;
import tools.Random;
import animation.BoxHighlighter;

class HorizontalBar extends Tile {
	public static var NAME = "FFOpenVN-Horizontal-Bar-" + Random.Get(10000);
	public static var ID = 0; 
	private var texts : Array<String>;
	private var images : Array<String>;
	private var ul : JQuery;
	private var li : Array<JQuery>;
	
	public function new() {
		super();
		HorizontalBar.ID += 1; 
		this.texts = [];
		this.HTML("<ul class=\"horizontal-bar\" id=\"" + HorizontalBar.NAME + HorizontalBar.ID + "\"></ul>");
		this.ul = new JQuery("#" + HorizontalBar.NAME + HorizontalBar.ID );
		this.li = [];
	} // new
	
	public function Purge() { 
		this.ul.html("");
	} // Purge
	
	public function Icon( image : String, ?cb : Void -> Void ) { 
		this.images.push( image );
		var k = this.li.length;
		var stuff = "<li class=\"horizontal-bar horizontal-bar-li-" + k + "\" id='" + HorizontalBar.NAME + HorizontalBar.ID + "-li-" + k + "'>";
		stuff += "<button class=\"horizontal-bar-btn hbar-btn-" + k + "\" id=\"horizontal-bar-btn-" + k + "\">";
		stuff += "<img src=\"" + image + "\" alt=\"horizontal bar icon number " + k + "\" />";
		stuff += "</button>";
		stuff += "</li>";
		if ( k == 0 ) { 
			this.ul.html(stuff);
		} // if
		else { 
			this.ul.append(stuff);
		} // else
		this.li.push( new JQuery("#" + HorizontalBar.NAME + HorizontalBar.ID + "-li-" + k) );
		
		// Step 2: callbacks
		this.li[this.li.length - 1].click(function(e){ 
			if ( cb != null )
				cb();
		}); // click
	} // Icon
	
	public function Text( text : String, ?cb : Void -> Void ) { 
		this.texts.push(text);
		var k = this.li.length;
		var stuff = "<li class=\"horizontal-bar horizontal-bar-li-" + k + "\" id='" + HorizontalBar.NAME + HorizontalBar.ID + "-li-" + k + "'>";
		stuff += "<button class=\"horizontal-bar-btn hbar-btn-" + k + "\" id=\"horizontal-bar-btn-" + k + "\">";
		stuff += text;
		stuff += "</button>";
		stuff += "</li>";
		if ( k == 0 ) { 
			this.ul.html(stuff);
		} // if
		else { 
			this.ul.append(stuff);
		} // else
		this.li.push( new JQuery("#" + HorizontalBar.NAME + HorizontalBar.ID + "-li-" + k) );
		
		// Step 2: callbacks
		this.li[this.li.length - 1].click(function(e){ 
			if ( cb != null )
				cb();
		}); // click
	} // Text
} // HorizontalBar