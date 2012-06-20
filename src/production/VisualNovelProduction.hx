package production;
import visualnovel.VisualNovel;

class VisualNovelProduction {
	public static function main() { 
		// Step 1: Initialization
		var vn = new VisualNovel();
		
		// Step 2: Blank load
		var sd = [{
			layers : [],
			text : "",
			id : 0 ,
			parent_id : null ,
			children_id : [],
			owner_id : 0 ,
			fork_text : null ,
			fork_number : 0 ,
			fork_image : null
		}]; // sd
		vn.Load(sd);
		
		// Step 3: Setups
		vn.SetupCommitting(function(data) { trace(data); } );
		vn.SetupForking( function(cb : Int -> Void) { cb(0); } );
		vn.SetupPermission(0);
		vn.SetupStockpile([{ id : null, picture : null, picture_small : null, metadata : null }]);
	} // main
} // VisualNovelProduction