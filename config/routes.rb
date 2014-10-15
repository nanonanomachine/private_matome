PrivateMatome::Application.routes.draw do
  # devise_for :users
  # Use custom controller for devise
  devise_for :users, :controllers => {
  :sessions => 'users/sessions',
  :passwords => 'users/passwords',
  :registrations => 'users/registrations'
}

  match 'users/:id' => 'users#show', :via => :get

  resources :users, only: [:edit] do
    member do
      get 'password'
    end
    collection do
      patch 'update_password'
      patch 'update_avatar'
    end
  end

  resources :groups do
    resources :lists , shallow: true do
      resources :items do
        member do
          patch 'up'
          patch 'down'
          patch 'ahead'
          patch 'backward'
        end
        collection do
          post 'create_text'
          post 'create_image'
          post 'create_link'
          post 'create_video'
        end
      end
    end
    resources :users, only: [:index]
    match 'users/:user_id', :controller => 'groupusers', :action => 'destroy', :as => 'user', :via => :delete
    match 'users/:user_id', :controller => 'groupusers', :action => 'add', :via => :post
    match 'admins/:user_id', :controller => 'groupusers', :action => 'assign_admin', :as => 'assign_admin', :via => :patch
    match 'moderators/:user_id', :controller => 'groupusers', :action => 'assign_moderator', :as => 'assign_moderator' ,:via => :patch
    match 'members/:user_id', :controller => 'groupusers', :action => 'assign_member', :as => 'assign_member', :via => :patch
  end

  match 'admin', :controller => 'admin', :action => 'index', :via => :get
  match 'admin/groups', :controller => 'admin', :action => 'groups', :via => :get

  #resources :groupusers
  #match 'groups/:id/users', :controller => 'groups', :action => 'add_users', :id => /\d+/, :via => :post, :as => 'group_users'
  #reosurces :groups do
  #  resources :users, :controller => 'Groupuser', :only => [:index, :create, :destroy]
  #end

  # get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
