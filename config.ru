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

  # Enable support for Rest parameters using _method
  use Rack::MethodOverride

  # Set up asset router for js and css
  use Asset::Router

  # Serve static files, for use with React or Vue
  # use Susana::Files

  # Set up session cookies
  use Rack::Session::Cookie,
    :path => '/',
    :expire_after => 2592000,
    :secret => '1eca29037f08b783cee7e77a958e01a4c7f2fa7dd9be61171709cf3e5f54ef65'

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
