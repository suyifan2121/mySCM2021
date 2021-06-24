Rails.application.routes.draw do
  devise_for :users
  resources :orders
  resources :members
  resources :users
  resources :items

  root 'orders#index'
  get 'renew/:id' => 'orders#renew'
  get 'return/:id' => 'orders#disable'
  get 'purchase_history' => 'orders#purchase_history'
  get 'sales_history' => 'orders#sales_history'
  get 'purchase_order' => 'orders#purchase_order'
  get 'sales_order' => 'orders#sales_order'

  get 'order_verify' => 'orders#verify'
  get 'order_reject' => 'orders#reject'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
