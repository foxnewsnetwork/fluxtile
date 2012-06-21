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
		vn.SetupPermission( untyped FluxTileBridge_Permission );
		vn.SetupStockpile( untyped FluxTileBridge_Stockpile );
	} // main
} // VisualNovelProduction