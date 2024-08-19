require 'rufus-scheduler'
require_relative '../../app/jobs/weather_data_job.rb'

scheduler = Rufus::Scheduler.new

scheduler.every '55m', first_in: '1s' do
  WeatherDataJob.perform_later
end
