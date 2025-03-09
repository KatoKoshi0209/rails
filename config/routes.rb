Rails.application.routes.draw do
  # Devise 用ルート（ユーザー認証関連）
  devise_for :users 

  # 管理者用のユーザー関連のルーティング
  namespace :administrator do
    # 管理者用ユーザー一覧
    resources :users, only: [:index, :edit, :update, :new, :create] do
      resources :attendances, only: [:index] # ユーザーに関連した出勤簿を表示
    end
  end

  # 他のユーザー関連のルート
  resources :attendances, only: [:new, :create, :update, :index, :show]
  resources :users, only: [:show, :edit, :update]

  # ログイン後のリダイレクト先
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end

