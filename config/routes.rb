Rails.application.routes.draw do
  resources :resultados
  resources :benchmarkings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/resultados/by_benchmark/:benchmarking_id", to: "resultados#show_by_benchmark"
  get "/resultados/:estado_1/:estado_2/:data_inicio/:data_fim", to: "resultados#comparativo"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
