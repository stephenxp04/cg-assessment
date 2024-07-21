Geocoder.configure(
  # Geocoding service (see below for supported services)
  lookup: :ipinfo_io, # or another supported service
  
  # API key for geocoding service
  api_key: ENV['GEOCODER_API_KEY'], # Ensure this key is correctly set
  
  # Timeout for requests (in seconds)
  timeout: 5,
  
  # Use HTTPS for geocoding requests
  use_https: true,
  
  # Language to use for geocoding responses
  language: :en
)
