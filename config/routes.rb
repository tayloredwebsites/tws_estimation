TwsAuth::Application.routes.draw do

  resources :sales_reps do
    member do
      put 'deactivate'      # route:          deactivate_sales_rep PUT    /sales_reps/:id/deactivate(.:format)          sales_reps#deactivate
      put 'reactivate'      # route:          reactivate_sales_rep PUT    /sales_reps/:id/reactivate(.:format)          sales_reps#reactivate
    end
  end
  match "sales_reps/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "sales_reps/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405

  get "assembly_components/menu" # route: assembly_components_menu GET    /assembly_components/menu(.:format)           assembly_components#menu
  resources :assembly_components do
    member do
      put 'deactivate'      # route: deactivate_assembly_component PUT    /assembly_components/:id/deactivate(.:format) assembly_components#deactivate
      put 'reactivate'      # route: reactivate_assembly_component PUT    /assembly_components/:id/reactivate(.:format) assembly_components#reactivate
    end
    collection do
      get 'list'            # route:      list_assembly_components GET    /assembly_components/list(.:format)           assembly_components#list
    end
  end
  match "assembly_components/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "assembly_components/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405


  get "assemblies/menu"     # route:         assemblies_menu GET    /assemblies/menu(.:format)                   assemblies#menu
  resources :assemblies do
    member do
      put 'deactivate'      # route:     deactivate_assembly PUT    /assemblies/:id/deactivate(.:format)         assemblies#deactivate
      put 'reactivate'      # route:     reactivate_assembly PUT    /assemblies/:id/reactivate(.:format)         assemblies#reactivate
    end
    collection do
      get 'list'            # route:         list_assemblies GET    /assemblies/list(.:format)                   assemblies#list
    end
  end
  match "assemblies/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "assemblies/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405

  get "components/menu"     # route:        components_menu GET    /components/menu(.:format)           components#menu
  resources :components do
    member do
      put 'deactivate'      # route:   deactivate_component PUT    /components/:id/deactivate(.:format) components#deactivate
      put 'reactivate'      # route:   reactivate_component PUT    /components/:id/reactivate(.:format) components#reactivate
    end
    collection do
      get 'list'            # route:        list_components GET    /components/list(.:format)           components#list
    end
  end
  match "components/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "components/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405

  resources :component_types do
    # resources :components # add routes like: component_type_components GET /component_types/:component_type_id/components(.:format) components#index
    member do
      put 'deactivate'      # route:    deactivate_component_type PUT    /component_types/:id/deactivate(.:format)    component_types#deactivate
      put 'reactivate'      # route:    reactivate_component_type PUT    /component_types/:id/reactivate(.:format)    component_types#reactivate
      # get 'new_component'   # route: new_component_component_type GET    /component_types/:id/new_component(.:format) component_types#new_component
    end
    collection do
    end
  end
  match "component_types/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "component_types/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405

  resources :users_sessions, :only => ['index', 'create'] do
    member do
      get 'signin'          # route:         signin_users_session GET    /users_sessions/:id/signin(.:format)         {:action=>"signin", :controller=>"users_sessions"}
      put 'signout'         # route:        signout_users_session PUT    /users_sessions/:id/signout(.:format)        {:action=>"signout", :controller=>"users_sessions"}
    end
  end
  match '/signin', :to => 'users_sessions#signin'
  match '/signout', :to => 'users_sessions#signout'
#   match '/reset_password', :to => 'users#reset_password'

  resources :users do
    # match 'deactivate'  # route:      user_deactivate        /users/:user_id/deactivate(.:format) {:action=>"deactivate", :controller=>"users"}
    # match 'reactivate'  # route:      user_reactivate        /users/:user_id/reactivate(.:format) {:action=>"reactivate", :controller=>"users"}
    member do
      put 'deactivate'      # route:              deactivate_user PUT    /users/:id/deactivate(.:format)      {:action=>"deactivate", :controller=>"users"}
      put 'reactivate'      # route:              reactivate_user PUT    /users/:id/reactivate(.:format)      {:action=>"reactivate", :controller=>"users"}
      get 'edit_password'   # route:           edit_password_user GET    /users/:id/edit_password(.:format)   {:action=>"edit_password", :controller=>"users"}
      put 'update_password' # route:         update_password_user PUT    /users/:id/update_password(.:format) {:action=>"update_password", :controller=>"users"}
    #   put 'reset_password'  # route:          reset_password_user PUT    /users/:id/reset_password(.:format)          {:action=>"reset_password", :controller=>"users"}
    end
    collection do
      get 'list'            # route:           list_users GET    /users/list(.:format)                         users#list
    end
  end
  match "users/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "users/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405
  match "users/:id/update_password", :via => :get, :to => 'home#errors', :status => 405
  
  resources :defaults do
    member do
      put 'deactivate'      # route:   deactivate_default PUT    /defaults/:id/deactivate(.:format)    defaults#deactivate
      put 'reactivate'      # route:   reactivate_default PUT    /defaults/:id/reactivate(.:format)    defaults#reactivate
    end
  end
  match "defaults/:id/deactivate", :via => :get, :to => 'home#errors', :status => 405
  match "defaults/:id/reactivate", :via => :get, :to => 'home#errors', :status => 405

  # routes for home controller
  get "home/index"            # route:           home_index GET    /home/index(.:format)                {:controller=>"home", :action=>"index"}
  get "home/about"            # route:           home_about GET    /home/about(.:format)                {:controller=>"home", :action=>"about"}
  get "home/contact"          # route:         home_contact GET    /home/contact(.:format)              {:controller=>"home", :action=>"contact"}
  get "home/errors"            # route:          home_errors GET    /home/errors(.:format)               {:controller=>"home", :action=>"errors"}
  get "home/news"              # route:            home_news GET    /home/news(.:format)                 {:controller=>"home", :action=>"news"}
  get "home/site_map"          # route:        home_site_map GET    /home/site_map(.:format)             {:controller=>"home", :action=>"site_map"}
  get "home/status"            # route:          home_status GET    /home/status(.:format)               {:controller=>"home", :action=>"status"}
  get "home/help"              # route:            home_help GET    /home/help(.:format)                 {:controller=>"home", :action=>"help"}
  root :to => "home#index"    # route:                 root        /(.:format)                          {:controller=>"home", :action=>"index"}
  match '/home', :to => "home#index"    # route:         home        /home(.:format)                      {:controller=>"home", :action=>"index"}
  
  # match '/readme', :to => redirect('/README.markdown')


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
