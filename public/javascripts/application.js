// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 
    $(".show_hide > h3").next().hide();
 
    $('.show_hide > h3').click(function(event) {
		target = $(event.currentTarget).next();
		// target = $("#assembly_7");
		// alert ("target = " + target.hasClass('margin_left_20'));
    	target.toggle();
    });

    $('.disable_when_off').click(function(event) {
		current_target = $(event.currentTarget);
		target = $("#assembly_"+current_target.val())
		if (current_target.attr("checked")) {
			target.show()
		} else {
			target.hide()
		}
    });


 
});
