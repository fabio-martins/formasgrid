Rails.application.routes.draw do
  resources :squares, path: "frames" do
    resources :circles, path: "circles"
  end

  # Additional routes for specific actions
  put "circles/:id", to: "circles#update"
  get "circles", to: "circles#index"
  delete "circles/:id", to: "circles#destroy"
  delete "frames/:id", to: "squares#destroy"
end
