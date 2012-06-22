package production;
import visualnovel.VisualNovel;

class VisualNovelProduction {
	public static function main() { 
		// Step 1: Initialization
		var vn = new VisualNovel();
		
		// Step 3: Setups
		vn.SetupCommitting(function(data) {  
			untyped FluxTileBridge_Commit(data);
		} ); // SetupCommitting
		vn.SetupForking( function(cb : Int -> Void) { 
			untyped FluxTileBridge_Fork( cb );
		} ); // SetupForking
		untyped FluxTileBridge_Load( vn );
	} // main
} // VisualNovelProduction