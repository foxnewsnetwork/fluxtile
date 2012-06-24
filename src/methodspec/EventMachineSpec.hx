package methodspec;
import events.Event;
import events.EventMachine;
import visualnovelevents.LayerDeleteEvent;

class EventMachineSpec extends haxe.unit.TestCase {
	
	private var faggot : String;
	
	public override function setup() { 
		this.faggot = "no one";
	} // setup
	public function testBasic() { 
		// anonymous events
		EventMachine.Listen( "faggot", function(e) { this.faggot = e.faggot; } );
		EventMachine.Fire({name : "faggot", origin : 12, faggot : "trevor" });
		this.assertEquals("trevor", this.faggot);
		
		
	} // testBasic
	public function testFaggot() { 
		// regular events
		trace("fj2048j204jg: " + this.faggot);
		EventMachine.Listen( LayerDeleteEvent.Name, function(e) { 
			if( e.id == 12 )
				this.faggot = "henry";
		 } ); // listen
		EventMachine.Fire(new LayerDeleteEvent(12, 15) );
		this.assertEquals("henry", this.faggot);
	}
} // EventMachineSpec