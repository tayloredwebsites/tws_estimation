// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 
    $(".show_hide").next().children().hide();
 
    $('.show_hide').click(function(event) {
		target = $(event.currentTarget).next().children();
		// target = $("#assembly_7");
		// alert ("target = " + target.hasClass('margin_left_20'));
    	target.toggle();
    });
 
});
