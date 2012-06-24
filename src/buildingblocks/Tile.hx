package buildingblocks;
import js.JQuery;
import statistics.Statistics;
import tools.Timer;
import tools.Tooltip;
import animation.Spotlight;

class Tile extends Element, implements Statistics {
	/***
	* Static Members Section
	**/
	public static var ID = 0;
	public static var SelectedTile : Tile = new Tile();
	
	/***
	* Private Members Section
	**/
	// Background div image
	private var image : String;
	// Callback array for click
	private var clicks : Array<JqEvent -> Void>;
	// Callback array for mouse over
	private var mouseovers : Array<JqEvent -> Void>;
	// Callback array for mouse leave
	private var mouseleaves : Array<JqEvent -> Void>;
	// Delete callback
	private var deletes : Array<Void -> Void>;
	// 0 is standard interactive, 1 is edit
	private var mode : Int;
	// User activity tracker
	public var stats : { mouseover : Array<Float>, duration : Array<Float>, click : Array<Float> };
	// edit_mode_initialized_flag
	private var edit_mode_initialized_flag : Bool;
	// flags for user interaction
	private var interaction : Hash<Bool>;
	
	/***
	* Inherited Public Functions
	**/
	public function Stats() : Dynamic { 
		return this.stats; 
	} //end GetStats
	public function ClearStats() : Dynamic{ 
		var tempstats = this.stats;
		this.stats = {mouseover : [], duration : [], click : []};
		return tempstats;
	} //end ClearStats
	
	/***
	* Public Function Section
	**/
	public function Delete( ?cb : Void -> Void ) { 
		if ( cb != null ) {
			this.deletes.push(cb);
			trace(cb);
		} // if null
		else {
			trace("deleting"); 
			for( delete in this.deletes ) { 
				delete();
			} // for
			this.Hide();
			this.Remove();
		} // else
	} // Delete
	
	// Returns the image url or changes it
	public function Image( ?url : String ) : String { 
		if( url == null ){ 
			return this.image;
		} // end if
		else if( this.image == url ){ 
			return this.image;
		} // end else
		this.image = url;
		this.CSS("background-image", "url('" + url + "')" );
		this.Size(this.NaturalSize());
		return this.image;
	} // Image
	
	// Gets the natural size of an image
	public function NaturalSize() { 
		this.domBody.append("<img id='tile-natural-size-finder-" + Tile.ID + "' src='" + this.image + "' style='position : absolute;'/>");
		var j = new JQuery( "#tile-natural-size-finder-" + Tile.ID );
		var s = { width : j.width() + 0.0, height : j.height() + 0.0 };
		j.replaceWith("");
		return s;
	} // NaturalSize
	
	// Returns the mode or changes it
	public function Mode( ?m : Int ) : Int { 
		if ( m != null ) { 
			this.mode = m;
			switch(this.mode) { 
				case 1 :
					this.p_EditMode();
				default :
					this.p_NormalMode();
			} // switch
			return m;
		} // if
		else {
			return this.mode;
		} // else
	} // Mode
	
	// Constructor
	public function new(){ 
		this.ClearStats();
		this.clicks = [];
		this.mouseovers = [];
		this.mouseleaves = [];
		this.deletes = [];
		super();
		this.CSS("z-index", "968");
		Tile.ID += 1;
		this.edit_mode_initialized_flag = false;
		this.interaction = new Hash<Bool>();
	} // end new
	
	// Click function call back registry
	public function Click( ?cb : JqEvent -> Void ){ 
		if( cb == null ){ 
			for( k in 0...this.clicks.length ){ 
				this.clicks[k](null);
				this.stats.click.push(haxe.Timer.stamp());
			} //end for
		} //end if
		else{ 
			this.clicks.push(cb);
			this.domContainer.click((function(tile : Tile){
				return function(e : JqEvent){
					tile.Click();
				}; // end return
			})(this)); // end click
		}// end else
	} // end Click
	
	// Mouseover function call back registry
	public function Mouseover( ?cb : JqEvent -> Void ){
		if( cb == null ){ 
			for( k in 0...this.mouseovers.length ){ 
				this.mouseovers[k](null);
				this.stats.mouseover.push(Timer.Start());
				this.interaction.set("mouseover", true);
			} //end for
		} //end if
		else{ 
			this.mouseovers.push(cb);
			this.domContainer.mouseover((function(tile : Tile){
				return function(e : JqEvent){
					tile.Mouseover();
				}; // end return
			})(this)); // end mouseover;
		}// end else 
	} //end Mouseover
	
	// Mouseleave function call back registry
	public function Mouseleave( ?cb : JqEvent -> Void ){ 
		if( cb == null ){ 
			for( k in 0...this.mouseleaves.length ){ 
				this.mouseleaves[k](null);
				this.stats.duration.push(Timer.Stop());
				this.interaction.set("mouseover", false);
			} //end for
		} //end if
		else{ 
			this.mouseleaves.push(cb);
			this.domContainer.mouseleave((function(tile : Tile){
				return function(e : JqEvent){
					tile.Mouseleave();
				}; // end return
			})(this)); // end mouseleave
		}// end else
	} //end Mouseleave
	
	public override function Hide(?cb : Void -> Void) { 
		super.Hide(cb);
		if ( Tile.SelectedTile == this)
			Spotlight.Die();
		this.interaction.set("visible", false);
	} // Hide
	
	public override function Show( ?cb : Void -> Void ) { 
		super.Show(cb);
		this.interaction.set("visible", true);
	} // Show
	/***
	* Private Function Section
	**/
	
	// Enters edit mode
	private function p_EditMode() : Void {
		if (this.edit_mode_initialized_flag)
			return;
		
		this.domContainer.bind("click", function(e : JqEvent) { 
			if ( Tile.SelectedTile != this ) { 
				Tile.SelectedTile = this;
				Spotlight.Shine(this.Size(), this.Position());
			} // if
		} ); // bind click 
		// Step 1: Manage mouseover and mouse leave UI
		var altdownflag = false;
		this.domContainer.bind("mouseover", function(e : JqEvent) { 
			if( this.mode != 1 )
				return;
			if ( Tile.SelectedTile == this ) { 
				if (altdownflag)
					Tooltip.Show("Resize Mode (Press SPACE to toggle mode)");
				else
					Tooltip.Show("Position mode (Press SPACE to toggle mode)");
				Tooltip.Append(" OR Press D to delete." );
			} // if
			else { 
				Tooltip.Show( "Click to select" );
			} // else
		} ); // end MouseOver
		this.domContainer.bind("mouseleave", function(e : JqEvent) { 
			if( this.mode != 1 )
				return;
			Tooltip.Hide();
		} ); // end mouseleave 
		
		// Step 2: Manage click-drag ui && resize ui
		var mousedownflag = false, xdiff = 0.0, ydiff = 0.0;
		
		this.domBody.keypress(function(e){ 
			if ( this.mode != 1 )
				return;
			if ( e.keyCode == 32 ) { 
				altdownflag = !altdownflag;
				if ( altdownflag )
					Tooltip.Show("Resize Mode (Press SPACE to toggle mode)");
				else
					Tooltip.Show("Position mode (Press SPACE to toggle mode)");
			} // if
			
			if ( e.keyCode == 100 ) { 
				trace( Tile.SelectedTile.Id() );
				if ( Tile.SelectedTile.Id() == this.Id() ) { 
					Spotlight.Die();
					Tooltip.Hide();
					this.Delete();
				} // if selected
			} // if delete 
			if ( e.keyCode == 109 ) {
				trace( e.keyCode ); 
				Tile.SelectedTile.Size( { width : js.Lib.window.innerWidth + 0.0, height : js.Lib.window.innerHeight + 0.0 } ) ;	
			} // if m
		}); // keypress
		this.domContainer.mousedown(function(e:JqEvent){
			if( this.mode != 1 )
				return;
			if( Tile.SelectedTile != this )
				return;
			mousedownflag = true; 
			var body = this.domBody;
			if ( this.type_position == "%" ) { 
				var mx = 100 * e.pageX / body.width();
				var my = 100 * e.pageY / body.height();
				xdiff = mx - this.position.x;
				ydiff = my - this.position.y;
			} // if
			else if ( this.type_position == "px" ) { 
				xdiff = e.pageX - this.position.x;
				ydiff = e.pageY - this.position.y;
			}
		} ); // end mousedown
		
		this.domContainer.mousemove(function(e:JqEvent){ 
			if( this.mode != 1 )
				return;
			if( Tile.SelectedTile != this )
				return;
			var topleft = this.Position();
			var dx = xdiff, dy = ydiff;
			var document = this.domBody;
			var mouseX, mouseY; 
			if ( this.type_position == "%" ) { 
				mouseX = 100 * e.pageX / document.width();
				mouseY = 100 * e.pageY / document.height();
			} // if
			else { 
				mouseX = e.pageX;
				mouseY = e.pageY;
			} // else
			
			if( mousedownflag && altdownflag) { 
				var w = mouseX < topleft.x ? 10.0 : mouseX - topleft.x + 10.0;
				var h = mouseY < topleft.y ? 10.0 : mouseY - topleft.y + 10.0;
				this.Size( { width : w, height : h } );
			} // if resizing
			else if (mousedownflag) {
				this.Position({ x : mouseX - dx, y : mouseY - dy }); // end position
			} // else if moving around
			Spotlight.Shine(this.Size(), this.Position());
			return;
		} ); //end mousemove
		this.domContainer.mouseup(function(e:JqEvent){ 
			if( this.mode != 1 )
				return;
			if( Tile.SelectedTile != this )
				return;
			mousedownflag = false;
		} ); // end mouseup
		
		// Step 3: Inject resize icon
		// TODO: write me!
		// Step 4: Manage drag-resize ui 
		// TODO: write me!
		this.edit_mode_initialized_flag = true;
	} // p_EditMode
	
	// Enters normal mode
	private function p_NormalMode() : Void { 
		Tile.SelectedTile = null;
		Spotlight.Die();
		Tooltip.Hide();
	} // p_NormalMode
} // Tile