Rails.application.routes.draw do
   resources :trackers
  get 'home' => 'trackers#current'
  get 'status' => 'trackers#status'
  get 'delete_all' => 'trackers#remove'
  get 'search' => 'application#search'
  get    '/trackers/:id' => 'trackers#show'
  #match 'wrapper' => 'trackers#testcod'#, via:[:get, :post]
  # get 'cleaner' => 'cleaner#testcod'
  # post 'cleaner/done' => 'cleaner#posttestcod'#, via:[:get, :post]
  # post 'cleaner/raw'=>'cleaner#htmlraw'
  # get 'nokocleaner' => 'trackers#testcod'
  # post 'nokocleaner/done' => 'trackers#posttestcod'
  get 'pending' => 'trackers#pending_tickets'
  get 'charts' => 'trackers#chart_page'
  post 'qc'=>'trackers#to_qc'
  post 'error'=>'trackers#error'
  post 'push'=>'trackers#to_push'
  post 'live'=>'trackers#live'
  post 'finished' => 'trackers#finished'
  


  resources :users
  get 'signup'  => 'users#new' 
  

  resources :sessions
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  root :to => 'sessions#new'

  #resources :dashboard
  get 'dashboard'=>'dashboard#index'
  get '/dashboard/outbound' =>'dashboard#outbound' 
  get '/dashboard/neutral' =>'dashboard#neutral'
  get '/dashboard/inbound' =>'dashboard#inbound'
  post '/assign' => 'dashboard#assign'
  get 'quality_check'=>'dashboard#qcin'
  get 'qc_remarks'=>'dashboard#qc_remarks'

  get 'news'=>'news#new'
  post '/news/generated'=>'news#news_gen'

get 'test1' =>'cleaner#test'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
