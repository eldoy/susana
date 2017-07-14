# Tell the app that we're not running console
$web = true

# Boot the app
require './config/boot.rb'

# Set up middleware stack
app = Rack::Builder.new do

  # Clean up requests
  use UTF8Cleaner::Middleware

  # Load images and fonts
  use Rack::Static,
    :urls => ['/images', '/fonts'],
    :root => App.assets,
    :header_rules => [
      [:all, {'Cache-Control' => 'public, max-age=31536000'}],
      [:fonts, {'Access-Control-Allow-Origin' => '*'}]
    ]

  # Set up caching, only in production and staging
  if %w[production staging].include?(App.env)
    use Rack::Cache,
      :metastore => 'file:./tmp/cache/rack/meta',
      :entitystore => 'file:./tmp/cache/rack/body',
      :verbose => false
  end

  # Set up asset router for js and css
  use Asset::Router

  # Set up session cookies
  use Rack::Session::Cookie,
    :path => '/',
    :expire_after => 2592000,
    :secret => 'a8976c0df4fb8a28f8fe979270443d37f239cf8da8f1bf9734ba'

  # Set up flash
  use Rack::Flash, :sweep => true

  # Extract parameters from post body
  use Rack::PostBodyContentTypeParser

  # Add support for JSONP
  use Rack::JSONP

  # Init request store
  use RequestStore::Middleware

  # Run app
  run App.new
end

run app
