Rails.application.routes.draw do
  root to: 'pages#story'
  get 'story', to: 'pages#story'
end
