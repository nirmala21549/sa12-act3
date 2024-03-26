require 'httparty'
require 'json'

def fetch_events(api_key, location)
  response = HTTParty.get("https://www.eventbriteapi.com/v3/events/search/?location.address=#{location}&token=#{api_key}")
  events_data = JSON.parse(response.body)

  if events_data['status_code'] == '401'
    puts "Error: Invalid API key."
    return []
  end

  events = events_data['events'] || []  
  return events
end

def display_events(events)
  if events.empty?
    puts "No events found."
    return
  end
  
  events.each do |event|
    name = event['name']['text']
    venue = event['venue']['name']
    start_time = event['start']['local']
    end_time = event['end']['local']
    puts "Event: #{name}"
    puts "Venue: #{venue}"
    puts "Start Time: #{start_time}"
    puts "End Time: #{end_time}"
    puts "-----------------------"
  end
end
api_key = 'H6HGIOSCKRSVQAMXHT'
location = 'New York'  
events = fetch_events(api_key, location)
display_events(events)
