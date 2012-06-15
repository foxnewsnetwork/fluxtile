package tests;
import visualnovel.VisualNovel; 
import visualnovel.SceneData;
import tools.Random;

class VisualNovelTest {
	public static function main() { 
		var vn = new VisualNovel();
		var sd = [];
		// Simulating data
		for( k in 0...50 ) { 
			var layers = [];
			for( j in 0...Random.Get(15) ) { 
				layers.push( { 
					image : "madotsuki.png" ,
					width : 25.0 ,
					height : 25.0 ,
					x : Random.Get(250) + 0.01,
					y : Random.Get(250) + 0.01
				} ); // layers.push
			} // for j
			sd.push( {
				layers : layers ,
				text : "Madotsuki scene number " + k ,
				id : k ,
				parent_id : null ,
				children_id : [] ,
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
		} );
		vn.Load(sd);
		vn.Start();
		
	} // main
} // VisualNovelTest