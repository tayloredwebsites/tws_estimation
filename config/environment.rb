# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TwsAuth::Application.initialize!

# code to automatically put field errors on right of field value
# replace field_with_errors code per http://ethilien.net/archives/fixing-divfieldwitherrors-in-ruby-on-rails/
# html safe per http://www.ruby-forum.com/topic/214623
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.match(/^<label/ ) || html_tag.match(/class="label"/)
    # this is a label
    "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe
  else
    # this is the value field
    out_str = "<span class=\"field_with_errors\">#{html_tag}"
    errs_str = ''
    if instance.error_message.size > 0
      instance.error_message.each do |msg|
        errs_str += '<span class="field_error">'+CGI.escapeHTML(msg)+'</span>'
      end
    end
    (out_str + errs_str + '</span>').html_safe
  end
end


