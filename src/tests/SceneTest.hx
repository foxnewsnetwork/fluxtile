package tests;
import visualnovel.Scene;
import visualnovel.SceneData;
class SceneTest {
	public static function main() {
		var s = new Scene();
		var sd = {
			layers : [
				{
					image : "madotsuki.png" ,
					width : 75.0 ,
					height : 75.0,
					x : 145.2 ,
					y : 15.0
				},
				{
					image : "madotsuki.png" ,
					width : 55.0 ,
					height : 35.0,
					x : 15.2 ,
					y : 65.0
				} ,
				{
					image : "madotsuki.png" ,
					width : 25.0 ,
					height : 25.0,
					x : 55.2 ,
					y : 25.0
				}
			], // layers
			text : "some sort of text for testing purposes goes here" ,
			id : "13412304" ,
			parent_id : "1834912834" ,
			children_id : ["2323048234", "2384813413"]
		} // sd
		
		s.Load(sd);
		s.Show();
	} // nmain
} // SceneTest