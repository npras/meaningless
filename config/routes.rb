Rails.application.routes.draw do

  root to: 'welcome#index'

  resources :sites do
    resources :discussions do
      resources :comments
    end
  end

  namespace :api do
    namespace :v1 do
    end
  end

  # /pageLikes.js
  get '/pageLikes' => "embeds#page_likes", as: :embed_page_likes, format: true

end
