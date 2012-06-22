package methodspec;
import visualnovel.VisualNovel;
import tools.Random;

class VisualNovelSpec extends haxe.unit.TestCase {
	/****
	* Before each
	**/
	private var vn : VisualNovel;
	public override function setup() { 
		this.vn = new VisualNovel();
	} // setup
	// end before each
	
	/****
	* describe permission
	**/
	public function setup_permission() { 
		trace( "setup_permission" );
		var user_id = Random.Get(9999);
		vn.SetupPermission( { user_id : user_id, level : 0 } );
		vn.Load([{
			layers : [] ,
			text : Random.Text(256) ,
			id : Random.Get(256) ,
			parent_id : null ,
			owner_id : user_id ,
			fork_text : Random.Text(256) ,
			fork_image : null ,
			fork_number : 0 , 
			children_id : []
		}]); // load
		vn.SetupStockpile([{
			id : Random.Get(2345),
			metadata : Random.Text(256),
			picture : "madotsuki.png",
			picture_small : "madotsuki.png"
		}]); // setupstockpile
		vn.SetupCommitting(function(data) { 
			trace(data);
		} ); // SetupCommitting
		var count = 50;
		vn.SetupForking( function( cb : Int -> Void ) { 
			count += 1;
			cb(count);
		} ); // SetupForking 
		trace( "end setup_permission" );
	} // setup_permission
	
	public function testAnonymous() { 
		// TODO: write me!
	} // testAnonymous
	// end permission
} // VisualNovelSpec