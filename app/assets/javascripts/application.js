
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

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
