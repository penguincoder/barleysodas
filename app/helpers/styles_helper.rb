module StylesHelper
  def new_style_link
    link_to 'New Style', new_style_path, { :title => 'Create a new style' }
  end
  
  def show_style_link(style)
    link_to style.title, style_path(style), { :title => style.title }
  end
  
  def edit_style_link(style)
    link_to 'Edit Style', edit_style_path(style),
      { :title => "Edit #{style.title}" }
  end
end
