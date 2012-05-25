PageAPI::Application.routes.draw do
  namespace :api do
    namespace :pages do
      get 'published', :as => 'published'
      get 'unpublished', :as => 'unpublished'
    end
    resources :pages do
      post 'publish', :as => 'publish'
      get 'total_words', :as => 'total_words'
    end
  end
end
