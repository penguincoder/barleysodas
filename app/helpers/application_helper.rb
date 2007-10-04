module ApplicationHelper
  ##
  # Returns the title for a page. This could be a Page title or something else.
  #
  def page_title
    return @page.title if @page
    "BarleySodas :: #{controller_class_name.gsub(/Controller/, '')}"
  end
  
  ##
  # Returns a link for a Page model.
  #
  def link_to_page(page)
    link_to page.title, page_path({ :id => page.title_for_url })
  end
end
