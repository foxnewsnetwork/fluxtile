package datastructures;

// Trees must have nodes and leafs 
class Tree <T>{
	public static function Create<T>( data : T ) : TreeNode<T> { 
		var root = TreeNode.Plant(data);
		return root;
	} // create<T>
} // Tree

class TreeNode<T> { 
	private var parent : TreeNode<T>;
	private var children : Array<TreeNode<T>>;
	private var data : T;
	
	/****
	* Static methods
	***/
	public static function Plant<T>(seed : T) : TreeNode<T> { 
		var root = new TreeNode<T>();
		root.parent = null;
		root.children = [];
		root.data = seed;
		return root;
	} // Seed
	
	/****
	* Public accessor methods
	***/
	public function Parent() : TreeNode<T> { 
		return this.parent;
	} // Parent
	
	// Creates a child
	public function Branch( data : T) : TreeNode<T> { 
		var child = new TreeNode<T>();
		child.parent = this;
		child.parent.children.push(child);
		child.data = data;
		return child;
	} // Child
	
	// returns the children
	public function Children() : Array<TreeNode<T>> { 
		return this.children;
	} // Children
	
	public function Data(?d : T) : T {
		if ( d != null ) 
			this.data = d;
		return this.data;
	} // Data
	/****
	* Macros
	***/
	// Roots have no parents
	public function IsRoot() : Bool { 
		if( this.parent == null ) { 
			return true;
		} // if
		else { 
			return false;
		} // else
	} // IsRoot
	
	// Leaves have no children
	public function IsLeaf() : Bool { 
		if( this.children.length == 0 )
			return true;
		else
			return false;
	} // IsLeaf
	/****
	* Private methods
	***/
	private function new(){ 
		this.children = [];
	} // new 
} // TreeNode