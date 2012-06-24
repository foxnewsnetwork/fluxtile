package events;

// Static events class to handle events throwing etc.
// e is suppose to be an event, but due to lack of polymorphism in haxe
// we are declaring it dynamic 
class EventMachine {
	public static var event_storage = new Hash< Array< Dynamic -> Void > >();
	
	public static function Listen( name : String, cb : Dynamic -> Void ) { 
		if ( !EventMachine.event_storage.exists(name) )
			EventMachine.event_storage.set(name, [function(e) { trace(e); } ]);	
		EventMachine.event_storage.get(name).push( cb );
	} // Listen
	
	public static function Fire( e : Dynamic ) { 
		if ( !EventMachine.event_storage.exists(e.name) )
			return;
		for( handler in EventMachine.event_storage.get(e.name) ) { 
			handler(e);
		} // for
	} // Fire
} // EventMachine