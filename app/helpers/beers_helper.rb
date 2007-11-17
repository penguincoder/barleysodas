module BeersHelper
  def new_beer_link
    link_to 'New Beer', new_beer_path, { :title => 'Create a new beer' }
  end
  
  def show_beer_link(beer)
    link_to 'Show', beer_path(beer.page.title_for_url),
      { :title => beer.title }
  end
  
  def edit_beer_link(beer)
    link_to 'Edit Beer', edit_beer_path(beer.page.title_for_url),
      { :title => "Edit #{beer.title}" }
  end
end
