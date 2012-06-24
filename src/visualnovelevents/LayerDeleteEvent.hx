package visualnovelevents;
import events.Event;

class LayerDeleteEvent extends Event {
	public static var Name = "layer delete event"; 
	public var id : Int;
	
	public function new( id : Int, origin : Int ) { 
		super( LayerDeleteEvent.Name , origin );
		this.id = id;
	} // new
} // LayerDeleteEvent