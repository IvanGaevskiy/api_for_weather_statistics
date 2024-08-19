#==============================================================================
#
# Как работает класс?
# 
# Для использования инициализируйте экземпляр класса 
# и вызовите на нём метод generate_data.
# 
#   weather = WeatherData.new
#   weather.generate_data
#   
#==============================================================================
#
# Для получения данных используйте следующие методы:
#   weather.current_temp => Текущая температура;
#   weather.data_compact => Почасовая температура за последние 24;
#   weather.historical_temp.max => Максимальная температура за 24 часа;
#   weather.historical_temp.min => Минимальная температура за 24 часа;
#   weather.historical_temp.avg => Средняя температура за 24 часа;
#   weather.temp_by_time(timestamp) => Температура, ближайшая к переданному timestamp/или 404
#   
#==============================================================================

# Описание основного метода generate_data:
#   1. generate_data получает основные погодные json-данные 
#   за последние 24 часа из https://developer.accuweather.com/ через API;
#   2. Записывает данные в @data;
#   3. Записывает компактные данные в @data_compact;
#   4. Записывает копактные данные в Redis, со сроком хранения 1 час(3600 сек);
#   5. Если данные уже в Redis и срок их хранения не истёк, 
#      то сразу записывает компактные данные в из Redis в @data_compact.
#      
#==============================================================================


require 'uri'
require 'net/http'
require 'json'
require 'redis'
require 'logger'
require 'time'
require_relative 'array_avg.rb'
require 'dotenv'
Dotenv.load

class WeatherData
  attr_reader :data_compact

  def initialize
    @data = []
    @data_compact = {}
    @logger = Logger.new(STDOUT)
    @redis = Redis.new
  end

  def generate_data
    if @redis.exists("weather_data") && @redis.ttl("weather_data") > 0

      @data_compact = JSON.parse(@redis.get("weather_data"))
      @logger.info("Данные загружены из Redis. Осталось хранить #{@redis.ttl("weather_data")} сек.")
      # @redis.del("weather_data")
    else
      uri = URI.parse("http://dataservice.accuweather.com/currentconditions/v1/#{location_key}/historical/24?apikey=#{accuweather_api_key}&language=en-us&details=false")

      response = Net::HTTP.get_response(uri)
      response_code = JSON.parse(response.code)

      if response_code == 200
        @data = JSON.parse(response.body)
        @data_compact = { temp_history_24h: historical_temp_with_time_24h, city_key: location_key }

        @redis.setex("weather_data", 3600, @data_compact.to_json)
        @logger.info("Данные загружены из API и сохранены в Redis. Обращение к API 1 раз в час.")
      else
        @logger.info("Отрицательный ответ от сервера №#{response_code}. #{response.message}.")
      end
    end
  end

  def current_temp
    @data_compact["temp_history_24h"][0]["temperature"]
  end

  def historical_temp
    result = []
    @data_compact["temp_history_24h"].each do |el| 
      temperature = el["temperature"]
      result << temperature 
    end
    result
  end
  
  def temp_by_time(user_timestamp)
    closest_time = @data_compact["temp_history_24h"].min_by do |time|
      weather_timestamp = Time.parse(time["date_time"]).to_i
      (weather_timestamp - user_timestamp).abs
    end
    closest_timestamp = Time.parse(closest_time["date_time"]).to_i
    if (closest_timestamp - user_timestamp).abs <= 3600
      closest_time['temperature']
    else
      false
    end
  end

  def location_key
    ENV['YOUR_LOCATION_KEY']
  end

  def accuweather_api_key
    ENV['ACCUWEATHER_API_KEY']
  end

  private

  def historical_temp_with_time_24h
    result = []
    @data.each do |el|
      time = Time.parse(el["LocalObservationDateTime"])
      temperature = el["Temperature"]["Metric"]["Value"]
      result << {"date_time" => time, "temperature" => temperature}
    end
    result
  end
end
