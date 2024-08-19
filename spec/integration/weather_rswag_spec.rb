require 'swagger_helper'

RSpec.describe 'Weather API', type: :request do
  puts "START SWAGGER TESTS."
  path '/weather/current' do
    get 'Получить текущую температуру' do
      tags 'Погода'
      produces 'application/json'
      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 current_temp: { type: :number },
                 city_key: { type: :string }
               },
               required: [ 'current_temp', 'city_key' ]

        run_test!
      end
    end
  end

  path '/weather/historical' do
    get 'Получить почасовую температуру за последние 24ч' do
      tags 'Погода'
      produces 'application/json'
      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 temp_history_24h: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       date_time: { type: :string, format: :date_time },
                       temperature: { type: :number }
                     },
                     city_key: { type: :string },
                     required: ['date_time', 'temperature']
                   }
                 }
               },
               required: ['temp_history_24h', 'city_key']

        run_test!
      end
    end
  end

  path '/weather/historical/max' do
    get 'Получить максимальную температуру за последние 24ч' do
      tags 'Погода'
      produces 'application/json'
      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 max_temp_24h: { type: :number},
                 city_key: { type: :string }
              },
              required: ['max_temp_24h', 'city_key' ]

        run_test!
      end
    end
  end

  path '/weather/historical/min' do
    get 'Получить минимальную температуру за последние 24ч' do
      tags 'Погода'
      produces 'application/json'
      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 min_temp_24h: { type: :number},
                 city_key: { type: :string }
              },
              required: ['min_temp_24h', 'city_key' ]

        run_test!
      end
    end
  end

  path '/weather/historical/avg' do
    get 'Получить среднюю температуру за последние 24ч' do
      tags 'Погода'
      produces 'application/json'
      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 avg_temp_24h: { type: :number},
                 city_key: { type: :string }
              },
              required: ['avg_temp_24h', 'city_key' ]

        run_test!
      end
    end
  end

  path '/weather/by_time/{timestamp}' do
    get 'Получить температуру ближайшую к переданному timestamp' do
      tags 'Погода'
      produces 'application/json'
      parameter name: 'timestamp', in: :path, type: :string, description: 'Timestamp для поиска температуры погоды по временной метке'

      response '200', 'успешный ответ' do
        schema type: :object,
               properties: {
                 temp_by_time: { type: :number },
                 city_key: { type: :string }
               },
               required: ['temp_by_time', 'city_key']

        let(:timestamp) { "#{Time.now.to_i - 86400}" }

        run_test!
      end

      response '404', 'не найдено' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: ['error']

        let(:timestamp) { "#{Time.now.to_i + 3601}" }

        run_test!
        puts "FINISH SWAGGER TESTS." 
      end
    end
  end
end