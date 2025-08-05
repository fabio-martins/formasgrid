Rails.application.routes.draw do
  mount Rswag::Ui::Engine  => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :v1 do
    resources :frames do
      resources :circles, only: [ :index, :create, :show, :update, :destroy ]
    end

    resources :circles, only: [ :index, :update, :destroy ]
  end
end
