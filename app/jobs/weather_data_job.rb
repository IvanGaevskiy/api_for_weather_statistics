require_relative '../../app/api/weather_data.rb'
require 'application_job'

class WeatherDataJob < ApplicationJob
  queue_as :default

  def perform
    weather = WeatherData.new
    weather.generate_data
  end
end
