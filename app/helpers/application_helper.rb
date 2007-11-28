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
    return h(@content_title) if @content_title
    controller.class.to_s.gsub(/Controller/, '')
  end
  
  ##
  # Returns a secondary title for a page. Returns @secondary_title or the
  # action in the controller.
  #
  def secondary_title
    return h(@secondary_title) if @secondary_title
    params[:action].to_s.capitalize.gsub(/_/) do |x|
      $1.capitalize
    end
  end
  
  ##
  # Returns a link for a Page model.
  #
  def link_to_page(page)
    link_to h(page.title), page_path({ :id => page.title_for_url })
  end
  
  ##
  # Helper to set the allow_discussions field in the Page model.
  #
  def allow_page_discussions
    @page.allow_discussions = true
  end
  
  ##
  # Helper to check if Discussion is allowed. This should check the underlying
  # permissions first instead of looking in the model.
  #
  def discussions_allowed?
    @page and @page.allow_discussions?
  end
end
