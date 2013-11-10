require 'resque/server'

Pugwarriors::Application.routes.draw do
  resources :authentications
  resources :games
  resources :tweets
  resources :comments

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  if ENV["RESQUE_WEB_PASS"]
    Resque::Server.use Rack::Auth::Basic do |username, password|
      password = ENV["RESQUE_WEB_PASS"]
    end
  end

  mount Resque::Server.new, :at => "/resque"

  mount Foundation::Icons::Rails::Engine => '/fi'
  match '/users/signout' => 'sessions#destroy', :as => :signout
  match '/games/:id/join' => 'games#join'
  match '/games/:id/leave' => 'games#leave'
  match '/games/:id/admin' => 'games#admin'
  match '/users/:id/games' => 'users#games'
  match '/games/:id/comments' => 'comments#create'
  match '/games/filter' => 'games#filter'
  match '/tweets/filter' => 'tweets#filter'
  match '/application/viewed_notification' => 'application#viewed_notification'
  match '/tweets/get_new_tweets' => 'tweets#get_new_tweets'
  match '/auth/:provider/callback' => 'authentications#create'
end
