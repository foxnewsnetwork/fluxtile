package monsters;
import js.JQuery;

// Monsters are floating form-tabs sort of things that are summoned by the favorites bar
class Cookies extends Monster {
	/***
	* Public Methods
	**/
	public function new() { 
		// Step 1: Initializing
		super();
				
		// Step 2: inputs
		var cookies = js.Cookie.all();
		var id = 0; 
		var context = "";
		for( key in cookies.keys() ) { 
			var nid = "name-" + Monster.NAME + Monster.ID;
			var vid = "value-" + Monster.NAME + Monster.ID; 
			context += "<h3>";
			context += "<input type='text' id='" + nid + "' value='" + key + "' /> :";
			context += "<input type='text' id='" + vid + "' value='" + cookies.get(key) + "' />";
			context += "</h3>";
			this.Prepend(context);
			this.inputs.push( { name : new JQuery("#" + nid), value : new JQuery("#" + vid) } );
			Monster.ID += 1;
		} // for
		
		// Step 3: click ui
		this.ui.get("submit").Click(function(e){ 
			for( k in this.inputs ) { 
				var nJq = k.name.val();
				var vJq = k.value.val();
				js.Cookie.set(nJq, vJq, 100);
				js.Lib.window.location.reload();
			} // for
		}); // Click
	} // new
} //  Cookies