# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :accounts, only: [ :index ] do
    collection do
      post :send_money
      post :receive_money
    end

    resources :transactions, only: [ :index ]
  end
end
