module BeersHelper
  def new_beer_link
    link_to "Beer Me!", new_beer_path, { :title => 'Create a new beer' }
  end
  
  def abv(beer)
    number_to_percentage(beer.abv, { :precision => 1 })
  end
end
