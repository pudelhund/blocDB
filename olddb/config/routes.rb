RoutenDb::Application.routes.draw do
  get "index/new"

  get "sessions/new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  match "/boulders/:id/showcomments" => "boulders#showcomments"

  root :to => "index#new"
  
  match "/boulders/:id/deactivate" => "boulders#deactivate"
  match "/boulders/:id/tick/:type/:event_id/:user_id" => "boulders#tick"
  match "/boulders/:id/untick/:event_id/:user_id" => "boulders#untick"  
  match "/boulders/all" => "boulders#all"
  match "/boulders/todo" => "boulders#todo"
  match "/boulders/conquerored" => "boulders#conquerored"
  match "/boulders/:id/togglemod" => "boulders#togglemod"
  match "/boulders/:id/rate/:rating" => "boulders#rate", :constraints => { :rating => /.*/ }
 # map.connect '/boulders/:id/rate/:rating', :controller =>'boulders#rate', :requirements => { :rating => /.*/ }
  match "/boulders/:id/climbers" => "boulders#climbers"
  match "/boulders/:id/climbers/:compare_id" => "boulders#climbers"
  match "/boulders/:id/reporterror" => "boulders#report_error"
  match "/boulders/massedit" => "boulders#massedit"
  match "/boulders/lastweek" => "boulders#lastweek"

  match "/boulder_errors/:id/togglecheck" => "boulder_errors#togglecheck"

  match "/events/:id/boulders" => "events#boulders"
  match "/events/:id/rankings" => "rankings#index", :type => "event", :eventid => :id
  match "/events/active" => "events#active"
  match "/events/inactive" => "events#inactive"

  match "/rankings/:type" => "rankings#index"
  match "/rankings/event/:eventid" => "rankings#index", :type => "event"

  get "rankings_points" => "rankings#index", :type => "points"
  get "rankings_amount" => "rankings#index", :type => "amount"
  get "rankings_alltime" => "rankings#index", :type => "alltime"


  match "/users/register" => "users#register"
  match "/users/:id/resetpassword" => "users#resetpassword"
  match "/users/:id/chgpassword" => "users#chgpassword"
  match "/users/:id/compareto/:compare_id" => "users#compareto"
  
  match "/users/:id/reportdoubt/:boulderid" => "users#report_doubt"
  match "/boulder_doubts/:id/togglecheck" => "boulder_doubts#togglecheck"
  
  match "/index/showlocationselect" => "index#show_location_popup"
  match "/users/:user_id/saveLocationPreference/:location_id" => "users#save_location_preference"

  resources :sessions

  resources :events


  resources :boulders


  resources :boulder_errors
  
  resources :boulder_doubts


  resources :comments


  resources :colors


  resources :walls


  resources :locations


  resources :users

  resources :admin
  
  resources :options
  match "/options/save" => "options#save"

 # resources :rankings

  # DUMMY ROUTES FOR NOT YET EXISTING PAGES 
  get "edit_todo" => "users#new", :as => "edit_todo"
  get "boulders_done" => "users#new", :as => "boulders_done"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
