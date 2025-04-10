OpenRouter.configure do |config|
  config.access_token = ENV["OPENROUTER_API_KEY"]
  config.site_name = 'Podcast Agent'
  config.site_url = 'https://podcast-agent.chat'
end

Raix.configure do |config|
  config.openrouter_client = OpenRouter::Client.new do |config|
    config.faraday do |f|
      f.request :retry, {max: 3, interval: 0.05, backoff_factor: 2, interval_randomness: 0.5}
      f.response :logger, ::Logger.new($stdout),{headers: true, bodies: true, errors: true} do |logger|
        logger.filter(/(Bearer) (\S+)/, '\1[REDACTED]')
      end
    end
  end
end
