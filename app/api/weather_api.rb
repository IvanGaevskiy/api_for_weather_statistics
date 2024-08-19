require 'grape'
require_relative 'weather_data'

class WeatherApi < Grape::API
  format :json

  resource :weather do
    before do
      @weather = WeatherData.new
      @weather.generate_data
    end

    desc 'Get current temperature'
    get :current do
      { current_temp: @weather.current_temp, city_key: @weather.location_key }
    end

    desc 'Get hourly temperature for the last 24 hours'
    get :historical do
      @weather.data_compact
    end

    desc 'Get max temperature for the last 24 hours'
    get 'historical/max' do
      { max_temp_24h: @weather.historical_temp.max, city_key: @weather.location_key }
    end

    desc 'Get min temperature for the last 24 hours'
    get 'historical/min' do
      { min_temp_24h: @weather.historical_temp.min, city_key: @weather.location_key }
    end

    desc 'Get average temperature for the last 24 hours'
    get 'historical/avg' do
      { avg_temp_24h: @weather.historical_temp.avg, city_key: @weather.location_key }
    end

    desc 'Find temperature nearest to the given timestamp'
    params do
      requires :timestamp, type: Integer, desc: 'Timestamp for temperature'
    end
    get 'by_time/:timestamp' do
      timestamp = @weather.temp_by_time(params[:timestamp])
      if timestamp.is_a?(Numeric)
        { temp_by_time: timestamp, city_key: @weather.location_key }
      else
        status 404
        { error: 'Not Found' }
      end
    end
  end

  resource :health do
    get do
      { status: 'OK' }
    end
  end
end
