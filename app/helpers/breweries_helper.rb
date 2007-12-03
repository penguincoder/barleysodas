module BreweriesHelper
  def new_brewery_link
    link_to 'New Brewery', new_brewery_path,
      { :title => 'Create a new brewery' }
  end
  
  def show_brewery_link(brewery)
    link_to brewery.title, brewery_path(brewery.page.title_for_url),
      { :title => brewery.title }
  end
  
  def edit_brewery_link(brewery)
    link_to 'Edit Brewery', edit_brewery_path(brewery.page.title_for_url),
      { :title => "Edit #{brewery.title}" }
  end
end
