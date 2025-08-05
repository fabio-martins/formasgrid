Rails.application.routes.draw do
  resources :frames do
    resources :circles, only: [:index, :create, :show, :update, :destroy]
  end

  resources :circles, only: [:index, :show, :update, :destroy]
end
