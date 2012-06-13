package visualnovel;

// Fork handles the UI and whatnot to help with selection
// Think of them as scene-transitions
class Fork {
	/****
	* Private member class
	**/
	private var origin_scene_id : Int;
	private var target_scene_id : Int;
	private var text : String;
	private var choice_number : Int;
	
	/****
	* Public methods class
	**/
	public function new() { 
	} // new
	
	public function Text() { 
		return text;
	} // Text
	
	public function Load( scenedata : SceneData ) { 
		this.text = scenedata.fork_text;
		this.target_scene_id = scenedata.id;
		this.origin_scene_id = scenedata.parent_id;
		this.choice_number = scenedata.fork_number;
	} // Load
	
	public function GetHash() { 
		return this.origin_scene_id + "-" + this.target_scene_id;
	} // GetHash
	
	public function Choice() { 
		return this.choice_number;
	} // Choice
} // Fork