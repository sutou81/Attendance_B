Rails.application.routes.draw do

  root 'static_pages#top'
  get  '/signup', to: 'users#new'
  
  # ログイン機能
  get   '/login', to: 'sessons#new'
  post  '/login', to: 'sessons#create'
  delete '/logout', to: 'sessons#destroy'

end
