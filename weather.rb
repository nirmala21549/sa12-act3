require 'httparty'
require 'json'

def fetch_weather_data(city, api_key)
  response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}")
  weather_data = JSON.parse(response.body)

  if weather_data['cod'] == 401
    puts "Error: Invalid API key. Please check your API key and try again."
    return nil
  end

  temperature = weather_data['main']['temp']
  humidity = weather_data['main']['humidity']
  weather_conditions = weather_data['weather'].first['description']

  return temperature, humidity, weather_conditions
end

def calculate_average_temperature(city, api_key, period_in_hours)
  total_temperature = 0.0

  (0...period_in_hours).each do |hour|
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{api_key}")

    weather_data = JSON.parse(response.body)

    if weather_data['cod'] == 401
      puts "Error: Invalid API key. Please check your API key and try again."
      return nil
    end

    temperature = weather_data['list'][hour]['main']['temp']
    total_temperature += temperature
  end

  average_temperature = total_temperature / period_in_hours
  return average_temperature
end

api_key = 'd8127c0e055786c64a9d3608744d3a3f'
city = 'Hyderabad'

temperature, humidity, weather_conditions = fetch_weather_data(city, api_key)
if temperature && humidity && weather_conditions
  puts "Current Weather in #{city}:"
  puts "Temperature: #{temperature} K" 
  puts "Humidity: #{humidity}%"
  puts "Weather Conditions: #{weather_conditions}"
else
  puts "Failed to fetch weather data."
end

period_in_hours = 24
average_temperature = calculate_average_temperature(city, api_key, period_in_hours)
if average_temperature
  puts "Average Temperature over #{period_in_hours} hours: #{average_temperature} K"
else
  puts "Failed to calculate average temperature."
end
