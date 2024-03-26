require 'httparty'
require 'json'

def get_exchange_rate(api_key, base_currency, target_currency)
  response = HTTParty.get("https://api.exchangerate-api.com/v4/latest/#{base_currency}")
  exchange_data = JSON.parse(response.body)

  if exchange_data['error']
    puts "Error: #{exchange_data['error']}"
    return nil
  end
  
  exchange_rate = exchange_data['rates'][target_currency]
  return exchange_rate
end

def convert_currency(amount_usd, exchange_rate)
  amount_inr = amount_usd * exchange_rate
  return amount_inr
end
api_key = nil 
base_currency = 'USD'
target_currency = 'INR'
exchange_rate = get_exchange_rate(api_key, base_currency, target_currency)

if exchange_rate
  amount_usd = 100  
  amount_inr = convert_currency(amount_usd, exchange_rate)
  puts "#{amount_usd} #{base_currency} is equal to #{amount_inr.round(2)} #{target_currency}"
else
  puts "Failed to fetch exchange rate."
end
