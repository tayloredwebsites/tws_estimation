module ApplicationHelper

  # # page title method to place title from page into layout file
  # def page_title (pg_title)
  #   content_for(:page_title) {
  #     (pg_title.nil?) ? "" : pg_title
  #   }
  # end
  # 
  # def view_errors_on(obj, field)
  #   out_string = ''
  #   if obj.errors[field].size > 0
  #     obj.errors[field].each do |msg|
  #       if out_string != '' then out_string += ', ' end
  #       out_string += msg
  #     end
  #   end
  #   out_string
  # end
  
  def current_user_full_name
    @session.current_user_full_name if !@session.nil?
  end
    
end
