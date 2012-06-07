package tools;

class Timer {
	public static var TIME : Float = haxe.Timer.stamp();
	
	public static function Start() : Float{ 
		Timer.TIME = haxe.Timer.stamp();
		return Timer.TIME;
	} //end Start
	
	public static function Stop() : Float{ 
		var startTime : Float = Timer.TIME;
		var difference : Float = Timer.Start() - startTime;
		return difference;
	} // end Stop
} // Timer