package tests;
import datastructures.Tree;

class TreeTest {
	public static function main(){ 
		var t = Tree.Create(5);
		var t2 = t.Branch(12);
		var t3a = t2.Branch(34);
		var t3b = t2.Branch(25);
	} // main
} // TreeTest