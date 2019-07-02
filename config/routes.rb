Rails.application.routes.draw do

  root to: 'welcome#index'

  resources :sites do
    resources :discussions do
      resources :comments
    end
  end

  namespace :api do
    get 'discussion_likes' => 'discussion_likes#show'
    post 'discussion_likes' => 'discussion_likes#create'
    #resources :discussion_comments, only: [:index, :create]
  end

  # /pageLikes.js
  get '/pageLikes' => "embeds#page_likes", as: :embed_page_likes, format: true

end
