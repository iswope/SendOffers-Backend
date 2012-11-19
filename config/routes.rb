Backend::Application.routes.draw do
  resources :ads
  
  resources :clients

  resources :users
  

  match '/login' => 'admin#login'
  match '/login' => 'admin#login'
  match '/register' => 'admin#register'
  match '/reset_pass' => 'admin#reset_pass'
  match '/role_options' => 'admin#role_options'
  match '/savereg' => 'admin#savereg'
  match '/thankyou' => 'admin#thankyou'
  match 'ads/supplier_dash/:id' => 'ads#supplier_dash'
  match 'ads/supplier_ad/:id' => 'ads#supplier_ad'
  match 'ads/supplier_create/:id' => 'ads#supplier_create'
  match 'ads/get_lists_api/:id' => 'ads#get_lists_api'
  
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
