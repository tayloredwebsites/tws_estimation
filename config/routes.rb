TwsAuth::Application.routes.draw do

  resources :users do
    # match 'deactivate'  # route:      user_deactivate        /users/:user_id/deactivate(.:format) {:action=>"deactivate", :controller=>"users"}
    # match 'reactivate'  # route:      user_reactivate        /users/:user_id/reactivate(.:format) {:action=>"reactivate", :controller=>"users"}
    member do
      put 'deactivate'      # route:      deactivate_user PUT    /users/:id/deactivate(.:format)      {:action=>"deactivate", :controller=>"users"}
      put 'reactivate'      # route:      reactivate_user PUT    /users/:id/reactivate(.:format)      {:action=>"reactivate", :controller=>"users"}
      get 'edit_password'   # route:   edit_password_user GET    /users/:id/edit_password(.:format)   {:action=>"edit_password", :controller=>"users"}
      put 'update_password' # route: update_password_user PUT    /users/:id/update_password(.:format) {:action=>"update_password", :controller=>"users"}
      put 'reset_password'  # route:  reset_password_user PUT    /users/:id/reset_password(.:format)  {:action=>"reset_password", :controller=>"users"}
    end
  end

  # routes for home controller
  root :to => "home#index"	# route:                 root        /(.:format)                          {:controller=>"home", :action=>"index"}
  get "home/index"	        # route:           home_index GET    /home/index(.:format)                {:controller=>"home", :action=>"index"}
  get "home/about"	        # route:           home_about GET    /home/about(.:format)                {:controller=>"home", :action=>"about"}
  get "home/contact"	      # route:         home_contact GET    /home/contact(.:format)              {:controller=>"home", :action=>"contact"}
  get "home/errors"	        # route:          home_errors GET    /home/errors(.:format)               {:controller=>"home", :action=>"errors"}
  get "home/news"	          # route:            home_news GET    /home/news(.:format)                 {:controller=>"home", :action=>"news"}
  get "home/site_map"	      # route:        home_site_map GET    /home/site_map(.:format)             {:controller=>"home", :action=>"site_map"}
  get "home/status"	        # route:          home_status GET    /home/status(.:format)               {:controller=>"home", :action=>"status"}
  get "home/help"	          # route:            home_help GET    /home/help(.:format)                 {:controller=>"home", :action=>"help"}

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
