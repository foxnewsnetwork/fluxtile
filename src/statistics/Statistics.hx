package statistics;

interface Statistics {
	public var stats : { 
		mouseover : Array<Float>,
		duration : Array<Float>,
		click : Array<Float>
	};
	public function Stats() : Dynamic;
	public function ClearStats() : Dynamic;
} // Statistics