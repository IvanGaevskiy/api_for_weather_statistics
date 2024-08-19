require_relative '../../app/api/weather_data'

RSpec.describe WeatherData do
  let(:weather) { WeatherData.new }

  before do
    weather.generate_data
  end

  describe '#current_temp' do
    puts "START. current_temp test."
    it 'возвращает текущую температуру' do
      expect(weather.current_temp).to be_a(Numeric)
    puts "FINISH. current_temp => Numeric. OK.."
    end
  end

  describe '#data_compact' do
    puts "START. data_compact test."
    it 'возвращает хэш с почасовой температурой за последние 24 часа' do
      data = weather.data_compact
      expect(data).to be_a(Hash)
      expect(data).to have_key("city_key")
      expect(data).to have_key("temp_history_24h")
      expect(data["temp_history_24h"]).to be_an(Array)
      expect(data["temp_history_24h"].size).to eq(24)
      expect(data["temp_history_24h"]).to all(be_a(Hash))
      expect(data["temp_history_24h"].first).to have_key("date_time")
      expect(data["temp_history_24h"].first).to have_key("temperature")
      puts "FINISH. data_compact => Array[{Hash},{Hash}...]. OK.."
    end
  end

  describe '#historical_temp.max' do
    puts "START. historical_temp.max test."
    it 'возвращает максимальную температуру за последние 24 часа' do
      max_temp = weather.historical_temp.max
      expect(max_temp).to be_a(Numeric)
      puts "FINISH. historical_temp.max => Numeric. OK."
    end
  end

  describe '#historical_temp.min' do
    puts "START. historical_temp.min test."
    it 'возвращает минимальную температуру за последние 24 часа' do
      min_temp = weather.historical_temp.min
      expect(min_temp).to be_a(Numeric)
      puts "FINISH. historical_temp.min => Numeric. OK."
    end
  end

  describe '#historical_temp.avg' do
    puts "START. historical_temp.avg test."
    it 'возвращает среднюю температуру за последние 24 часа' do
      avg_temp = weather.historical_temp.avg
      expect(avg_temp).to be_a(Numeric)
      puts "FINISH. historical_temp.avg => Numeric. OK."
    end
  end

  describe '#temp_by_time/:timestamp' do
    puts "START. temp_by_time/:timestamp-not_empty test."
    context 'когда данные для timestamp есть' do
      let(:timestamp) { Time.now.to_i - 86400}

      it 'возвращает температуру, ближайшую к переданному timestamp' do
        temp = weather.temp_by_time(timestamp)
        expect(temp).to be_a(Numeric)
        puts "FINISH. temp_by_time/:timestamp-not_empty => Numeric. OK."
      end
    end

    context 'когда данных для timestamp нет' do
      puts "START. temp_by_time/:timestamp-empty test."
      let(:timestamp) { Time.now.to_i + 3601 }

      it 'возвращает false' do
        temp = weather.temp_by_time(timestamp)
        expect(temp).to eq(false)
        puts "FINISH. temp_by_time/:timestamp-empty => Numeric. OK."
      end
    end
  end
end
