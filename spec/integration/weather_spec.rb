require 'rails_helper'
require 'swagger_helper'
require 'benchmark'
require_relative '../../app/api/array_avg'

NUM_RPS = 5
average_time = []
RSpec.describe 'Weather API', type: :request do
  describe 'GET /weather/current' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START INTEGRATION TESTS WEATHER."
      puts "START. GET /weather/current"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i
      
      total_time = Benchmark.realtime do
        requests_count.times do
          get '/weather/current'
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('current_temp')
          expect(json_response).to include('city_key')
          expect(json_response['current_temp']).to be_a(Numeric)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/current"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/historical' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/historical"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get '/weather/historical'
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('temp_history_24h')
          expect(json_response).to include('city_key')
          expect(json_response['temp_history_24h']).to be_a(Array)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/historical"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/historical/max' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/historical/max"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get '/weather/historical/max'
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('max_temp_24h')
          expect(json_response).to include('city_key')
          expect(json_response['max_temp_24h']).to be_a(Numeric)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/historical/max"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/historical/min' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/historical/min"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get '/weather/historical/min'
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('min_temp_24h')
          expect(json_response).to include('city_key')
          expect(json_response['min_temp_24h']).to be_a(Numeric)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/historical/min"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/historical/avg' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/historical/avg"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get '/weather/historical/avg'
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('avg_temp_24h')
          expect(json_response).to include('city_key')
          expect(json_response['avg_temp_24h']).to be_a(Numeric)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/historical/avg"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/by_time/timestamp if not empty' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/by_time/timestamp if not empty"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get "/weather/by_time/#{ Time.now.to_i - 86400}"

          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('application/json')

          json_response = JSON.parse(response.body)
          expect(json_response).to include('temp_by_time')
          expect(json_response).to include('city_key')
          expect(json_response['temp_by_time']).to be_a(Numeric)
          expect(json_response['city_key']).to be_a(String)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/by_time/timestamp if not empty"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
    end
  end

  describe 'GET /weather/by_time/timestamp if empty' do
    it "handles #{NUM_RPS} RPS (requests per second)" do
      puts "START. GET /weather/by_time/timestamp if empty"
      duration = 1.0
      requests_count = (NUM_RPS * duration).to_i

      total_time = Benchmark.realtime do
        requests_count.times do
          get "/weather/by_time/#{ Time.now.to_i + 3601 }"

          expect(response).to have_http_status(:not_found)
        end
      end
      average_time << total_time
      puts "FINISH. GET /weather/by_time/timestamp if empty"
      puts "Total time for #{requests_count} requests: #{total_time.round(2)} seconds\n\n"
      expect(total_time).to be <= duration + 0.1
      puts "END OF EXECUTION WEATHER SPEC."
      puts "Average time for #{requests_count} requests: #{average_time.avg.round(2)} seconds\n\n"
    end
  end
end
