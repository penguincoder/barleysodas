module PagesHelper
  def new_page_link
    link_to 'New Page', new_page_path, { :title => 'Create a new page' }
  end
  
  def show_page_link(page, better_title = 'Show')
    link_to better_title, page_path(page), { :title => page.title }
  end
  
  def edit_page_link(page)
    link_to 'Edit Page', edit_page_path(page),
      { :title => "Edit #{page.title}" }
  end
end
