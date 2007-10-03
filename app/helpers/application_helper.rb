module ApplicationHelper
  ##
  # Returns the title for a page. This could be a Page title or something else.
  #
  def page_title
    return @page.title if @page
    "BarleySodas :: #{controller_class_name.gsub(/Controller/, '')}"
  end
end
