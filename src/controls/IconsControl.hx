package controls;
import buildingblocks.Tile;
import js.JQuery;
import tools.Random;

// Like the text controller, except holds lots of pictures
class IconsControl extends Tile {
	// Constants
	public static var ListsPerPage = 2;
	public static var IconsPerList = 5;
	public static var NAME = "FFOpenVN-IconsControl-" + Random.Get(999999); 
	
	// Tile containers
	private var lists : Array<JQuery>;
	// Tiles for pictures
	private var icons : Array<JQuery>;
	// Page tracker
	private var page : Int;
	// Page indicator
	private var ipage : Tile;
	// next page
	private var inext : Tile;
	// previous page
	private var iprevious : Tile;
	
	// Public functions
	public function new() {
		super();
		this.lists = [];
		this.icons = [];
		this.page = 0;
		this.ipage = new Tile();
		this.ipage.ClassName("iconscontrol-ui iconscontrol-pagename");
		this.inext = new Tile();
		this.inext.ClassName("iconscontrol-ui iconscontrol-nextbtn");
		this.inext.HTML("Next");
		this.inext.Click(function(e){ 
			this.Next();
		}); // Click
		this.iprevious = new Tile();
		this.iprevious.ClassName("iconscontrol-ui iconscontrol-prevbtn");
		this.iprevious.HTML("Previous");
		this.iprevious.Click(function(e){ 
			this.Previous();
		}); // Click
		
	} // new
	
	public function AddIcon( img : String, cb : Void -> Void ) { 
		// Step 1: Setting up
		var n = this.icons.length;
		var icon_html = "<li class='li-iconscontrol-icon iconscontrol-icon-" + n + "'>";
		icon_html += "<button class='btn-iconscontrol-icon' id='btn-" + IconsControl.NAME + "-" + n + "'>";
		icon_html += "<img src='" + img + "' class='li-iconscontrol-icon' /></button></li>";
		if ( IconsControl.IconsPerList * ( this.lists.length ) <= n ) { 
			this.Append("<ul class='iconscontrol-icon-ul' id='ul-" + IconsControl.NAME + "-" + this.lists.length + "'></ul>");
			this.lists.push( new JQuery("#ul-" + IconsControl.NAME + "-" + this.lists.length ) );
		} // if > max capacity	
		this.lists[this.lists.length-1].append(icon_html);
		this.icons.push( new JQuery("#btn-" + IconsControl.NAME + "-" + n) );
				
		// Step 3: Setting up callbacks
		this.icons[n].click(function(e){
			if( cb != null )
				cb();
		}); // Click
		
		this.icons[n].mouseover((function(n) { 
			return function(e){ 
				this.icons[n].css("border", "1px solid red");
			}; // return
		} )(n) ); // Mouseover
		
		this.icons[n].mouseleave((function(n) { 
			return function(e){ 
				this.icons[n].css("border", "0px solid red");
			}; // return
		} )(n) ); // Mouseleave
	} // AddIcon
	
	public function Next() : Void { 
		var maxPage = Math.ceil(this.lists.length / IconsControl.ListsPerPage);
		this.page += this.page < maxPage - 1 ? 1 : 0; 
		this.p_resize();
	} // Next
	
	public function Previous() : Void {  
		this.page -= this.page > 0 ? 1 : 0;
		this.p_resize();
	} // Previous
	
	// public override functions
	public override function Size( ?siz : { width : Float, height : Float } ) : { width : Float, height : Float } { 
		var s = super.Size(siz);
		if( siz != null ) { 
			p_resize();
		} // if
		return s;
	} // Size
	
	public override function Position( ?pos : { x : Float, y : Float } ) : { x : Float, y : Float } { 
		var p = super.Position(pos);
		if( pos != null ) { 
			p_resize();
		} // if
		return p;
	} // Position 
	
	public override function Show(?cb : Void -> Void ) { 
		super.Show(cb);
		this.inext.Show();
		this.iprevious.Show();
		this.ipage.Show();
		this.p_resize();
	} // Show
	
	public override function Hide( ?cb : Void -> Void ) { 
		super.Hide(cb);
		this.inext.Hide();
		this.iprevious.Hide();
		this.ipage.Hide();
		for( list in this.lists ) { 
			list.hide();
		} // for
	} // Hide
	// private utliity functions
	private function p_resize() {
		// Step 1: Set up shortcuts 
		var s = this.Size();
		var p = this.Position();
		
		var start = this.page * IconsControl.ListsPerPage;
		var finish = start + IconsControl.ListsPerPage > this.lists.length ? this.lists.length : start + IconsControl.ListsPerPage;
		
		// Step 2: Move tiles around
		for( list in this.lists ) { 
			list.hide();
		} // for
		for( k in start...finish ) {
			this.lists[k].show();
		} // for
		
		// Step 3: Move the UI
		this.ipage.HTML(this.page + "");
		/***
		this.inext.Position({ x : p.x + s.width, y : p.y });
		this.iprevious.Position({ x : p.x, y : p.y });
		this.ipage.Position({ x : p.x + s.width / 2, y : p.y });
		
		**/
	} // p_resize
} // IconsControl