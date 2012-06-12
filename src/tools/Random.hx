package tools;

// Macros for generating convenient integer randoms
class Random {
	// Defaults to between 0 -> 99 (inclusive)
	public static function Get( ?upper_cap : Int ) : Int { 
		var cap = 100;
		if( upper_cap != null )
			cap = upper_cap;
		return Math.floor( Math.random() * cap );
	} // Get
} // Random