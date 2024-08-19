Rails.application.routes.draw do
  mount WeatherApi => '/'
  
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
