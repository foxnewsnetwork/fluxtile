package monsters;
import buildingblocks.Tile;
import js.JQuery;
import tools.Random;

class Monster extends Tile{
	public static var NAME : String = "TILE-MONSTER-" + Random.Get(999999); 
	public static var ID : Int = 0;
	
	/***
	* Private member functions
	**/
	private var inputs : Array<{ name : JQuery, value : JQuery } >;
	private var ui : Hash<Tile>;
	
	/***
	* Public Methods
	**/
	public function new() { 
		// Step 1: Initializing
		super();
		this.ui = new Hash<Tile>();
		this.inputs = new Array<{ name : JQuery, value : JQuery }>();
		
		// Step 1.5: UI setup
		for( k in ['submit','new', "close"] ) { 
			var t = new Tile();
			t.HTML(k);
			t.CSS("border", "1px solid blue");
			t.Mouseover( function(e) { 
				t.CSS("border", "2px solid red");
			} ); // Mouseover
			
			t.Mouseleave( function(e){ 
				t.CSS("border", "1px solid blue");
			} ); // Mouseleave
			this.ui.set(k, t);
			t.Size( { width : 70.0, height : 55.0 } );
		} // for
		
			
		
		// Step 3.5: close UI
		this.ui.get("close").Click(function(e){ 
			this.Hide();
		} ); // click
		
		// Step 4: new ui
		this.ui.get("new").Click(function(e){
			var nid = "name-" + Monster.NAME + Monster.ID;
			var vid = "value-" + Monster.NAME + Monster.ID;
			var context = "";
			context += "<h3>";
			context += "<input type='text' id='" + nid + "' placeholder='name' /> :";
			context += "<input type='text' id='" + vid + "' placeholder='value' />";
			context += "</h3>";
			this.Prepend(context);
			this.inputs.push( { name : new JQuery("#" + nid), value : new JQuery("#" + vid) } );
			Monster.ID += 1; 
		} ); // Click
		
		// Step 5: Styling
		this.Position({ x : 20.0, y : 70.0 });
		this.CSS("border", "1px solid black");
		this.ui.get("new").Position({ x : 20.0 , y : 0.0 });
		this.ui.get("submit").Position({ x : 90.0, y : 0.0 });
		this.ui.get("close").Position({ x : 160.0, y : 0.0 });
	} // new
	
	public override function Hide( ?cb : Void -> Void ) { 
		super.Hide(cb);
		for( k in this.ui ) { 
			k.Hide();
		} // for
	} // Hide
	
	public override function Show( ?cb : Void -> Void) { 
		super.Show(cb);
		for( k in this.ui ) { 
			k.Show();
		} // show
	} // Show
} // Monster