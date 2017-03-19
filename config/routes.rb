class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  namespace :events do
    get 'participants/index'
  end

  namespace :events do
    get 'participants/create'
  end

  namespace :events do
    get 'participants/destroy'
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth",
  }

  devise_scope :user do
    get "sign_in", to: "users/profile#sign_in", as: :new_session
    get "sign_out", to: "devise/sessions#destroy"
  end

  # Static pages
  %w(welcome about).each do |page_name|
    get page_name, to: "pages##{page_name}"
  end

  get 404, to: "errors#not_found"

  get "sign_up/complete", to: "users/profile#sign_up_complete"
  get "profile", to: "users/profile#profile"

  scope "profile" do
    get   "edit", to: "users/profile#edit", as: :edit_profile
    get   "settings", to: "users/profile#settings", as: :profile_settings
    patch "settings_update", to: "users/profile#settings_update"
  end

  resources :users do
    collection do
      get :active
      get :recent
    end
    resource :avatars, only: [:create, :destroy], controller: "users/avatars"
  end

  resources :photos, only: [:index]

  draw :events
  draw :places

  get :feed, to: "events#feed", defaults: { format: 'rss' }

  draw :admin

  root "pages#welcome"
end
