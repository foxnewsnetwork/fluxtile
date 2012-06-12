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
				children_id : []
			} ); // sd.push
		} // for k
		
		// simulation part 2
		for ( k in 0...25 ) { 
			sd[k].parent_id = k - 1 > 0 ? k - 1 : null;
			sd[k].children_id = k + 1 < 25 ? [k + 1] : null ; 	
		} // for
		for( k in 25...50 ) {
			sd[k].parent_id = k - 25;
			sd[k].children_id = null;
		} // for 
		vn.Load(sd);
		vn.Start();
	} // main
} // VisualNovelTest