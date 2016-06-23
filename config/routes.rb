Rails.application.routes.draw do

	root 'dashboard#index'

  devise_for :users do
  	get '/users/sign_out' => 'devise/sessions#destroy'
  end

	get '/help' => 'dashboard#help'
		
	resources :users, only: [] do
  	resources :crawlers do
  		get 'crawl'
  	end
  end
  
end
