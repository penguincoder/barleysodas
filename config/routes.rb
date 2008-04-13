ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => 'pages', :action => 'default_action'
  map.resources :pages, :roles, :sessions, :styles, :galleries, :tag_images,
    :friends, :experiences, :invitations, :peoples, :discussions
  map.resources :breweries do |breweries|
    breweries.resources :beers
  end
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
