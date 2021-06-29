Rails.application.routes.draw do
  devise_for :users
  resources :orders
  resources :members
  resources :users
  resources :items
  resources :suppliers
  resources :clients

  root 'orders#index'
  get 'renew/:id' => 'orders#renew'
  get 'return/:id' => 'orders#disable'
  get 'purchase_history' => 'orders#purchase_history'
  get 'sales_history' => 'orders#sales_history'
  get 'purchase_order' => 'orders#purchase_order'
  get 'sales_order' => 'orders#sales_order'

  get 'return_purchase' => 'orders#return_purchase'
  get 'return_sales' => 'orders#return_sales'
  get 'create_return' => 'orders#create_return'

  get 'order_verify' => 'orders#verify'
  get 'order_reject' => 'orders#reject'
  
  get 'view_report' => 'orders#view_report'
end
