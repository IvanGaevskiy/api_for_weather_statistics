# API для статистики по погоде

Это приложение поможет вам получить актуальные погодные данные за последние 24 часа.

Данные берёт из https://developer.accuweather.com/
Оптимизировано под большую нагрузку. Ниже описано как вы можете это проверить.

## Требования

- Ruby 3.0.2
- Rails 7.0.8

## Установка
### Интрукция для Linux

0. Откройте консоль
1. Клонируйте репозиторий: `git clone https://github.com/IvanGaevskiy/api_for_weather_statistics`
2. Перейдите в папку репозитория
3. Скопируйте файл с переменными окружения:`cp .env.example .env`
4. В файле .env добавьте в переменные значения. Получить эти данные можно с сайта https://developer.accuweather.com/. 

>Во второй переменной по умолчанию установлен ключ города Москва

4. Запустите контейнер с приложением: `docker-compose up --build`

> Дождитесь окончания загрузки и запуска сервера

5. Проведите тестирование: `bundle exec rspec`
6. Сгенерируйте swagger-документацию: `rake rswag:specs:swaggerize`

### Как остановить приложение?

`docker-compose down`

## Использование

### Swagger-документация

Описание, какие конкретно значения возвращае эта API

http://localhost:3001/api-docs

### Api-url

<http://localhost:3001/weather/current> `=> Текущая температура`

http://localhost:3001/weather/historical `=> Почасовая температура за последние 24`

http://localhost:3001/weather/historical/max `=> Максимальная температура за 24 часа`

http://localhost:3001/weather/historical/min `=> Минимальная температура за 24 часа`

http://localhost:3001/weather/historical/avg `=> Средняя температура за 24 часа`

http://localhost:3001/weather/by_time/:timestamp `=> Температура, ближайшая к переданному timestamp/или 404
`
## Структура проекта

### Основные файлы проекта

Получение, и формирование конечных данных.
- *app/api/weather_data.rb*

Распределение данных по роутам через Grape, отправление ответа пользователю.
- *app/api/weather_api.rb*

Регулярное обновление данных.
- *config/initializers/sheduler.rb*
- *app/jobs/weather_data_job.rb*

### Тесты

Это описание нужно только для того, чтобы запустить тесты по отдельности.

#### Интеграционное тестирование данных

Протестируйте нагрузку. Для этого измените NUM_RPS = 5 на другое значение.
Тест не будет пройден, если время выполнения 
запросов на 1 api-url превысит 1 секунду.
- *spec/integration/weather_spec.rb*
- Запуск: `bundle exec rspec spec/integration/weather_spec.rb`

#### Тестирование Swagger-документации

- *spec/integration/weather_rswag_spec.rb*
- Запуск: `bundle exec rspec spec/integration/weather_rswag_spec.rb`

#### Тестирование основных методов получения погоды

- *spec/api/weather_data.rb*
- Запуск: `bundle exec rspec spec/api/weather_data.rb`