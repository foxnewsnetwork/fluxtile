$(document).ready(function(){
	Injector.Method( "post" );
	Injector.Name( 
	$("body").html(  );
} ); // document.ready

var Injector = (function(){
	var m = "post";
	var a = window.location.href;
	var n = [];
	var form;
	return { 
		Method : function(method) { m = method; } ,
		Push : function(name) { n.push( name );} ,
		Action : function(action) { a = action; } ,
		Inject : function() { 
			form = "<div id='inject-container' class='inject-container'>";
			form += "<form id='inject-form' class='inject-form' action='" + a + "' method='" + m + "'>";
			for( var k = 0; k < n.length; k++ ) { 
				form += "<input type='text' name='" + n[k] + "' />";
			} // for
			form += "<input type='submit' value='submit' />";
			form += "</form>";
			form += "</div>";
			$("body").append(form);
		} // Inject
	}; // return
})(); // Injector
