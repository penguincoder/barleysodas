ActionController::Routing::Routes.draw do |map|
  map.resources :beers, :breweries, :pages, :discussions, :peoples

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

  map.connect '/', :controller => 'pages', :action => 'default_action'
end
