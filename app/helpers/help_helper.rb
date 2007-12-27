module HelpHelper
  def show_help_link(page, better_title = 'Show')
    link_to better_title, help_path({ :id => page.title_for_url }),
      { :title => page.title }
  end
  
  def edit_help_link(page)
    link_to 'Edit Help Page', edit_help_path({ :id => page.title_for_url }),
      { :title => "Edit Help Page #{page.title}" }
  end
end
