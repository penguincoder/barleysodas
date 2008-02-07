module BeersHelper
  include BreweriesHelper
  
  def new_beer_link
    link_to 'New Beer', new_beer_path, { :title => 'Create a new beer' }
  end
  
  def show_beer_link(beer)
    link_to beer.title, beer_path(beer.page.title_for_url),
      { :title => beer.title }
  end
  
  def edit_beer_link(beer)
    link_to 'Edit Beer', edit_beer_path(beer.page.title_for_url),
      { :title => "Edit #{beer.title}" }
  end
  
  ##
  # Shows an add Experience link.
  #
  def add_experience_link
    link_to_function("#{image_tag('list-add.png')} Beverage Experience",
      "lightboxes['experienceDialog'].open()")
  end
  
  ##
  # Shows the remove Experience link.
  #
  def remove_experience_link(experience)
    link_to_remote "#{image_tag('list-remove.png')} Beverage Experience",
      :url => experience_url(:id => experience.id, :format => :xml),
      :method => :delete, :confirm => 'Are you sure?',
      :update => 'experience_container',
      :success => "new Effect.Highlight('experience_container', {duration: 1.5})"
  end
end
