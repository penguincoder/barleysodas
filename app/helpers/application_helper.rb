module ApplicationHelper
  ##
  # Returns the title for a page. This could be a Page title or something else.
  #
  def page_title
    "BarleySodas :: #{content_title} :: #{secondary_title}"
  end
  
  ##
  # Returns a pretty name for the current chunk.
  #
  def content_title
    return @content_title if @content_title
    controller.class.to_s.gsub(/Controller/, '')
  end
  
  ##
  # Returns a secondary title for a page. Returns @secondary_title or the
  # action in the controller.
  #
  def secondary_title
    return @secondary_title if @secondary_title
    params[:action].to_s.capitalize.gsub(/_/) do |x|
      $1.capitalize
    end
  end
  
  ##
  # Returns a link for a Page model.
  #
  def link_to_page(page)
    link_to page.title, page_path({ :id => page.title_for_url })
  end
end
