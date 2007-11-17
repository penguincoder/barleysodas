module PagesHelper
  def new_page_link
    link_to 'New Page', new_page_path, { :title => 'Create a new page' }
  end
  
  def show_page_link(page)
    link_to 'Show', page_path(page.title_for_url),
      { :title => page.title }
  end
  
  def edit_page_link(page)
    link_to 'Edit Page', edit_page_path(page.title_for_url),
      { :title => "Edit #{page.title}" }
  end
end
