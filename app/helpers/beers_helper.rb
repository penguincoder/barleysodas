module BeersHelper
  def abv(beer)
    number_to_percentage(beer.abv, { :precision => 1 })
  end
end
