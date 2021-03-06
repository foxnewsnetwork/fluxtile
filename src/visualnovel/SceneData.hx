package visualnovel;

typedef SceneData = {
	layers : Array<LayerData>,
	text : String ,
	id : Int ,
	parent_id : Int ,
	owner_id : Int ,
	fork_text : String ,
	fork_image : String ,
	fork_number : Int , 
	children_id : Array<Int>
} // SceneData
// please note the following:
// [id, parent_id] => unique 
// [id, parent_id, fork_number] => unique

