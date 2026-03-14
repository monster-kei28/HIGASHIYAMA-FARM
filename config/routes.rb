Rails.application.routes.draw do
  root "static_pages#top"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: redirect("/")

  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"
  get "contact", to: "static_pages#contact"
  get "guide", to: "static_pages#guide"

  resources :reservations, only: %i[new create show destroy] do
    collection do
      get  :search
      post :lookup
    end
  end

  namespace :admin do
    root "dashboard#show"

    get "login", to: "sessions#new"
    delete "logout", to: "sessions#destroy"

    resources :reservations, only: %i[index show destroy]

    resources :admins, only: %i[index create destroy]

    resources :users, only: %i[index]

    resources :calendar_events, only: %i[index] do
      collection do
        post :bulk_update
      end
    end

        resources :harvest_experiences, only: %i[index destroy]
  end
end
