Rails.application.routes.draw do
  devise_for :users

  resources :calculations

  root to: 'calculations#new'
end
