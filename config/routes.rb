ActionController::Routing::Routes.draw do |map|
  map.resources :tag_images

  map.resources :beers, :breweries, :pages, :discussions, :peoples, :roles,
    :sessions, :styles, :galleries, :tag_images

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

  map.connect '/', :controller => 'pages', :action => 'default_action'
end
