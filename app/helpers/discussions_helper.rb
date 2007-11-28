module DiscussionsHelper
  ##
  # Returns a link to a Page model or to the Page owner if applicable.
  #
  def page_or_parent_link(page)
    if page.owner_type.to_s.empty?
      return link_to 'Show Wiki Page', page_path(page.title_for_url)
    end
    link_to("Show #{page.owner_type} Page",
      send("#{page.owner_type.downcase}_path", page.title_for_url))
  end
end
