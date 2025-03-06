Rails.application.routes.draw do
  devise_for :users # devise を使用する際に URL として users を含む
  resources :attendances, only: [:new, :index, :show]
  devise_scope :user do
    root to: "devise/sessions#new"
  end  
end
