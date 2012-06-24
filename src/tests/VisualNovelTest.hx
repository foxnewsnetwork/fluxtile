package tests;
import visualnovel.VisualNovel; 
import visualnovel.SceneData;
import tools.Random;
import methodspec.EventMachineSpec;

class VisualNovelTest {
	public static function main() { 
		var vn = new VisualNovel();
		var sd0 = [{
			layers : [] ,
			text : Random.Text(50) ,
			id : 1 ,
			parent_id : null ,
			children_id : null ,
			owner_id : 1 ,
			fork_text : null ,
			fork_image : null ,
			fork_number : null 
		}]; // sd0
		var sd = [];
		// Simulating data
		for( k in 0...50 ) { 
			var layers = [];
			for( j in 0...Random.Get(15) ) { 
				layers.push( {
					id : Random.Get(250) , 
					image : "madotsuki.png" ,
					width : 25.0 ,
					height : 25.0 ,
					x : Random.Get(250) + 0.01,
					y : Random.Get(250) + 0.01 ,
					element_id : Random.Get(250)
				} ); // layers.push
			} // for j
			sd.push( {
				layers : layers ,
				text : "Madotsuki scene number " + k + Random.Text(50),
				id : k ,
				parent_id : null ,
				children_id : [] ,
				owner_id : Random.Get(250) ,
				fork_text : "madotsuki scene choice " + k ,
				fork_image : null ,
				fork_number : k < 25 ? 0 : 1 ,
			} ); // sd.push
		} // for k
		
		// simulation part 2
		for ( k in 0...25 ) { 
			sd[k].parent_id = k > 0 ? k - 1 : null;
			sd[k].children_id.push( k + 1 ) ;
			sd[k].children_id.push( k < 25 ? k + 25 : null ); 	
		} // for
		for( k in 25...50 ) {
			sd[k].parent_id = k - 25;
			sd[k].children_id = null;
		} // for
		/*
		for( k in 0...sd.length ) { 
			trace( { id : sd[k].id, parent_id : sd[k].parent_id, children_id : sd[k].children_id, text : sd[k].text } );
		}  
		*/
		var count = 49;
		vn.SetupForking(function(cb : Int -> Void){ 
			// Step 1: Get count from server
			count++;
			
			// Step 2: Hit callback
			cb(count);
		} ); // SetupForking
		vn.SetupCommitting( function(data) { 
			trace(data);
		} ); // SetupCommitting
		var stockdata = [
			{ 
				id : Random.Get(156) ,
				picture : "madotsuki.png" ,
				picture_small : "madotsuki.png" ,
				metadata : "nothing here"
			}
		]; // stockdata
		vn.SetupStockpile(stockdata);
		vn.Load(sd0);
		vn.SetupPermission({ user_id : 12, level : 3 });
		vn.SetupDeleting(function(ids) { 
			trace(ids);
			trace("the event machine is working");
		} ); // SetupDeleting
		vn.Start();
		
		var runner = new haxe.unit.TestRunner();
		runner.add(new EventMachineSpec());
		runner.run();
	} // main
} // VisualNovelTest