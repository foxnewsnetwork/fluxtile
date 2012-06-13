package toolbar;
import buildingblocks.Tile;
import js.JQuery;
import tools.Random;

class VerticalBar extends Tile {
	public static var NAME = "FFOpenVN-Vertical-Bar-" + Random.Get(10000);
	public static var ID = 0; 
	private var texts : Array<String>;
	private var images : Array<String>;
	private var ul : JQuery;
	private var li : Array<JQuery>;
	
	public function new() {
		super();
		VerticalBar.ID += 1; 
		this.texts = [];
		this.HTML("<ul class=\"vertical-bar\" id=\"" + VerticalBar.NAME + VerticalBar.ID + "\"></ul>");
		this.ul = new JQuery("#" + VerticalBar.NAME + VerticalBar.ID );
		this.li = [];
	} // new
	
	public function Icon( image : String, ?cb : Void -> Void ) { 
		this.images.push( image );
		var k = this.li.length;
		var stuff = "<li class=\"vertical-bar vertical-bar-li-" + k + "\" id='" + VerticalBar.NAME + VerticalBar.ID + "-li-" + k + "'>";
		stuff += "<button class=\"vertical-bar-btn vbar-btn-" + k + "\" id=\"vertical-bar-btn-" + k + "\">";
		stuff += "<img src=\"" + image + "\" alt=\"vertical bar icon number " + k + "\" />";
		stuff += "</button>";
		stuff += "</li>";
		if ( k == 0 ) { 
			this.ul.html(stuff);
		} // if
		else { 
			this.li[this.li.length - 1].append(stuff);
		} // else
		this.li.push( new JQuery("#" + VerticalBar.NAME + VerticalBar.ID + "-li-" + k) );
		
		// Step 2: callbacks
		this.li[this.li.length - 1].click(function(e){ 
			if ( cb != null )
				cb();
		}); // click
	} // Icon
	
	public function Text( text : String, ?cb : Void -> Void ) { 
		this.texts.push(text);
		var k = this.li.length;
		var stuff = "<li class=\"vertical-bar vertical-bar-li-" + k + "\" id='" + VerticalBar.NAME + VerticalBar.ID + "-li-" + k + "'>";
		stuff += "<button class=\"vertical-bar-btn vbar-btn-" + k + "\" id=\"vertical-bar-btn-" + k + "\">";
		stuff += text;
		stuff += "</button>";
		stuff += "</li>";
		if ( k == 0 ) { 
			this.ul.html(stuff);
		} // if
		else { 
			this.li[this.li.length - 1].append(stuff);
		} // else
		this.li.push( new JQuery("#" + VerticalBar.NAME + VerticalBar.ID + "-li-" + k) );
		
		// Step 2: callbacks
		this.li[this.li.length - 1].click(function(e){ 
			if ( cb != null )
				cb();
		}); // click
	} // Text
} // VerticalBar