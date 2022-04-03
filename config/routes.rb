Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  post '/home/recipes-for-ingredients', to: 'home#recipes_for_ingredients'
end
