Rails.application.routes.draw do


  root to: 'welcome#index'


  resources :users

  scope module: :pras_devise do
    resources :registrations, only: [:new, :create]
    resources :confirmations, only: [:new, :show]
    resources :sessions, only: [:new, :create, :destroy]
    resources :password_resets, only: [:new, :edit, :create, :update]
  end

  resources :sites do
    resources :discussions do
      resources :comments
    end
  end


  namespace :api do
    get 'discussion_likes_and_comments' => 'discussions#likes_and_comments'

    post 'discussion_like' => 'discussions#create_like'
    post 'discussion_comment' => 'discussions#create_comment'
  end


  # /pageLikesAndComments.js
  get '/pageLikesAndComments' => "embeds#page_likes_and_comments", as: :embed_page_likes_and_comments, format: true


end
