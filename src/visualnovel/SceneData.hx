package visualnovel;

typedef SceneData = {
	layers : Array<{
		image : String ,
		width : Float ,
		height : Float ,
		x : Float ,
		y : Float
	}>,
	text : String ,
	id : Int ,
	parent_id : Int ,
	children_id : Array<Int>
} // SceneData