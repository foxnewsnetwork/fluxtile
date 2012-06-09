package controls;
import buildingblocks.Tile;

// Like the text controller, except holds lots of pictures
class IconsControl extends Tile {
	// Constants
	public static var IconsPerLine = 5;
	public static var IconsPerPage = 10;
	
	// Tiles for pictures
	private var icons : Array<Tile>;
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
		this.icons = [];
		this.page = 0;
		this.ipage = new TextControl();
		this.ipage.Size({ width : 15.0, height : 15.0 });
		this.inext = new Tile();
		this.inext.Size({ width : 15.0, height : 15.0 });
		this.inext.HTML("Next");
		this.inext.Click(function(e){ 
			this.Next();
		}); // Click
		this.iprevious = new Tile();
		this.iprevious.Size({ width : 15.0, height : 15.0 });
		this.iprevious.HTML("Previous");
		this.iprevious.Click(function(e){ 
			this.Previous();
		}); // Click
		super();
	} // new
	
	public function AddIcon( img : String, cb : Void -> Void ) { 
		// Step 1: Setting up
		var n = this.icons.length;
		this.icons.push( new Tile() );
		this.icons[n].Image(img);
		
		// Step 2: Configuring size
		// this.p_resize();
		
		// Step 3: Setting up callbacks
		this.icons[n].Click(function(e){
			if( cb != null )
				cb();
		}); // Click
		
		this.icons[n].Mouseover(function(e){ 
			this.icons[n].CSS("border", "1px solid red");
		}); // Mouseover
		
		this.icons[n].Mouseleave(function(e){
			this.icons[n].CSS("border", "none");
		}); // Mouseleave
	} // AddIcon
	
	public function Next() : Void { 
		var maxPage = Math.ceil(this.icons.length / IconsControl.IconsPerPage);
		this.page += 1;
		this.page %= maxPage;
		this.p_resize();
	} // Next
	
	public function Previous() : Void { 
		var maxPage = Math.ceil(this.icons.length / IconsControl.IconsPerPage); 
		this.page -= 1;
		this.page = this.page < 0 ? maxPage : this.page;
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
		for( k in 0...this.icons.length ) { 
			this.icons[k].Hide();
		} // for
	} // Hide
	// private utliity functions
	private function p_resize() {
		// Step 1: Set up shortcuts 
		var s = this.Size();
		var p = this.Position();
		var start = this.page * IconsControl.IconsPerPage > this.icons.length ? this.icons.length - IconsControl.IconsPerPage : this.page * IconsControl.IconsPerPage;
		var finish = start + IconsControl.IconsPerPage > this.icons.length ? this.icons.length : start + IconsControl.IconsPerPage;
		
		// Step 2: Move tiles around
		for( k in 0...this.icons.length ) { 
			this.icons[k].Hide();
		} // for
		for( k in start...finish ) {
			var j = k - start;  
			var iwidth = s.width / IconsControl.IconsPerLine < 20 ? 10: s.width / IconsControl.IconsPerLine - 10;
			var iheight = s.height / 2 < 20 ? 10 : s.height / 2 - 10; 
			this.icons[k].Size({ width : iwidth, height : iheight });
			var ix = p.x + iwidth * ( j % IconsControl.IconsPerLine ) + 15;
			var iy = p.y + iheight * Math.floor( j / IconsControl.IconsPerLine ) + 5;
			this.icons[k].Position({ x : ix, y : iy });
			this.icons[k].Show();
		} // for
		
		// Step 3: Move the UI
		this.inext.Position({ x : p.x + s.width, y : p.y });
		this.iprevious.Position({ x : p.x, y : p.y });
		this.ipage.Position({ x : p.x + s.width / 2, y : p.y });
	} // p_resize
} // IconsControl