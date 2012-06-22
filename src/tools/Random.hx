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
	
	public static function Text( ?len : Int ) : String { 
		var l = 100;
		if ( len != null )
			l = len;
		var alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','%','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
		var rand_arr = [];
		for( k in (0...l) )
			rand_arr.push( Random.Get(alphabet.length) );
		return Lambda.map(rand_arr, function(n) { return alphabet[n]; } ).join("");
	} // Text
} // Random