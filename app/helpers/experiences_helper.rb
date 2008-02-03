module ExperiencesHelper
  include BeersHelper
  include BreweriesHelper
  
  def experience_rating(experience)
    "<span id='rating_div_#{experience.id}' class='rating_container'></span>"
  end
end
