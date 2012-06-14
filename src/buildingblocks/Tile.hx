package buildingblocks;
import js.JQuery;
import statistics.Statistics;
import tools.Timer;

class Tile extends Element, implements Statistics {
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
	// 0 is standard interactive, 1 is edit
	private var mode : Int;
	// User activity tracker
	public var stats : { mouseover : Array<Float>, duration : Array<Float>, click : Array<Float> };
	
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
		return this.image;
	} // Image
	
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
		
		super();
		this.CSS("z-index", "968");
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
	/***
	* Private Function Section
	**/
	// Enters edit mode
	private function p_EditMode() : Void { 
		// Step 1: Manage mouseover and mouse leave UI
		this.Mouseover( function(e : JqEvent) { 
			if( this.mode != 1 )
				return;
			this.CSS("border", "2px solid blue");
		} ); // end MouseOver
		this.Mouseleave(function(e : JqEvent) { 
			if( this.mode != 1 )
				return;
			this.CSS("border", "none");
		} ); // end mouseleave
		
		// Step 2: Manage click-drag ui
		var mousedownflag = false, xdiff = 0.0, ydiff = 0.0;
		this.domContainer.mousedown(function(e:JqEvent){
			if( this.mode != 1 )
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
			if (mousedownflag) {
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
				this.Position({ x : mouseX - dx, y : mouseY - dy }); // end position
			} // end if
			return;
		} ); //end mousemove
		this.domContainer.mouseup(function(e:JqEvent){ 
			if( this.mode != 1 )
				return;
			mousedownflag = false;
		} ); // end mouseup
		
		// Step 3: Inject resize icon
		// TODO: write me!
		// Step 4: Manage drag-resize ui 
		// TODO: write me!
	} // p_EditMode
	
	// Enters normal mode
	private function p_NormalMode() : Void { 
		// TODO: Write me!
	} // p_NormalMode
} // Tile