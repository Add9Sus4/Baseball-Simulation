Rails.application.routes.draw do
  resources :achievements
  resources :transactions
  resources :drafts
  resources :season_team_stats
  resources :games
  resources :seasons
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  get 'pages/home'

  get 'pages/about'

  get 'pages/login'

  get 'pages/stats'

  get 'pages/test'

  get 'pages/leaders'

  get 'pages/draft'

  get 'pages/freeAgents'

  get 'signup' => 'users#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'seasons/currentSeason'


  resources :players do
    member do
      get 'showGameLog'
      get 'showPitchingStats'
      get 'showBattingStats'
      get 'showTransactions'
      get 'showFieldingStats'
      get 'showAchievements'
      get 'showPitchLocations'
    end
  end
  resources :teams do
    member do
      get 'edit_position'
      get 'batters'
      get 'pitchers'
      get 'editPitching'
      get 'editPositions'
      get 'schedule'
      get 'april'
      get 'may'
      get 'june'
      get 'july'
      get 'august'
      get 'september'
      get 'currentStandings'
      get 'minors'
      get 'transactions'
      get 'editLineup'
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  root 'pages#home'
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
