module ApplicationHelper

    # page title method to place title from page into layout file
    def page_title (pg_title)
        content_for(:page_title) { pg_title }
    end
    
end
