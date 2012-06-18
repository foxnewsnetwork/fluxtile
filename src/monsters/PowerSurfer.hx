package monsters;
import js.JQuery;

// Allows for get, post, delete, put, and patch requests
class PowerSurfer extends Monster {
	/***
	* Private members
	**/
	private var action : JQuery;
	private var method : JQuery;
	private var result : String;
	
	/***
	* Public functions
	**/ 
	public function new() { 
		// Step 1: setup
		super();
		var ctx = "<h3>Action : ";
		ctx += "<input type='text' id='action-" + Monster.NAME + Monster.ID + "' value='" + js.Lib.window.location.href + "'/>";
		ctx += "</h3><h3>Method : ";
		ctx += "<input type='text' id='method-" + Monster.NAME + Monster.ID + "' value='get' />";
		ctx += "</h3>";
		this.HTML(ctx);
		this.action = new JQuery("#action-" + Monster.NAME + Monster.ID);
		this.method = new JQuery("#method-" + Monster.NAME + Monster.ID);
		Monster.ID += 1;
		
		// Step 2: Callbacks
		this.ui.get("submit").Click(function(e){ 
			var req = new haxe.Http(this.action.val());
			var reqData = "";
			var meth = this.method.val();
			if ( (~/^get/i).match(meth) ) {
				for( k in this.inputs ) {
					req.setParameter(k.name.val(), k.value.val()); 
				} // for 
			} // if
			req.onData = (function(r : String) { 
				this.result = r;
				// TODO: something with the returned data
				trace( this.result );
			}); // onData
			req.request( ~/^post/i.match(meth) );
		} ); // submit.click
	} // new
} // PowerSurfer