Rails.application.routes.draw do
  
  
  # ログイン機能
  get   '/login', to: 'sessons#new'
  post  '/login', to: 'sessons#create'
  delete '/logout', to: 'sessons#destroy'
end
