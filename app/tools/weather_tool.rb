class WeatherTool < RubyLLM::Tool
  description "Gets current weather for a city"
  param :latitude, desc: "Latitude (e.g. 40.3916° N)"
  param :longitude, desc: "Longitude (e.g. 111.8508° W)"
  param :city, desc: "City, State, and optional Country (e.g. Lehi, Utah)"

  def execute(latitude:, longitude:, city:)
    conn = Faraday.new(url: 'http://api.openweathermap.org') do |f|
      f.response :json, content_type: /\bjson$/ # Parse JSON automatically
      f.adapter Faraday.default_adapter         # Use default HTTP adapter
    end

    api_key = ENV["OPENWEATHERMAP_API_KEY"]  # Replace with your OpenWeatherMap API key

    # Make GET request to OpenWeatherMap API
    response = conn.get('/data/2.5/weather') do |req|
      req.params['lat'] = latitude
      req.params['lon'] = longitude
      req.params['appid'] = api_key
    end

    answer = {}
    if response.success?
      data = response.body
      temp_celsius = data['main']['temp'] - 273.15  # Convert Kelvin to Celsius
      temp_fahrenheit = (temp_celsius * 9/5.0) + 32
      description = data['weather'][0]['description']
      answer["content"] = "Current weather in #{city}: #{temp_fahrenheit.round(1)}°F, #{description}"
    else
      answer["content"] = "Error fetching data: #{response.status} - #{response.body['message']}"
    end
    answer["content"]
  rescue => e
    { error: e.message }
  end
end
