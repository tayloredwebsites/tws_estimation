// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
 
    // hide all Assembly Components details by default
	$(".show_hide > h3").next().hide();
 
    // Show Assembly Components details when header is clicked
    $('.show_hide > h3').click(function(event) {
		target = $(event.currentTarget).next();
		// target = $("#assembly_7");
		// alert ("target = " + target.hasClass('margin_left_20'));
    	target.toggle();
    });

    // Update Assembly Components visibility when Assembly Checkbox is clicked
    $('.disable_when_off').click(function(event) {
		current_target = $(event.currentTarget);
		target = $("#assembly_"+current_target.val())
		if (current_target.attr("checked")) {
			target.show()
		} else {
			target.hide()
		}
    });

    // Only show Assembly Components when checked
    $('.disable_when_off').each(function(n) {
		// alert ("matched .disable_when_off for id = "+this.id+" = "+this.value );
		target = $("#assembly_"+this.value);
		// alert ("target = " + target.attr('id') );
		if (this.checked) {
			target.show()
		} else {
			target.hide()
		}
    });


 
});
