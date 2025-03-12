Rails.application.routes.draw do
  # Devise 用ルート（ユーザー認証関連）
  devise_for :users 

  # 管理者用のユーザー関連のルーティング
  namespace :administrator do
    # 管理者用ユーザー一覧
    resources :users, only: [:index, :edit, :update, :new, :create] do
      resources :attendances, only: [:index, :edit, :update] do
        collection do
          get :summary # これで `user_id` や `attendance_id` をURLに含めなくてもOK
        end
      end
    end
    # 管理者用シフト希望一覧
    resources :shift_requests, only: [:index]
    resources :shifts, only: [:index, :new, :create, :destroy, :edit, :update] 
  end  

  # 他のユーザー関連のルート
  resources :attendances, only: [:new, :create, :update, :index, :show]
  resources :users, only: [:show, :edit, :update]
  resources :shift_requests, only: [:index, :new, :create, :destroy]
  resources :shifts, only: [:index]

  # ログイン後のリダイレクト先
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end

