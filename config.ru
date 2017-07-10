# Tell the app that we're not running console
$web = true

# Init the app
require './config/boot.rb'

# Set up middleware stack
app = Rack::Builder.new do
  use UTF8Cleaner::Middleware

  use Rack::Static, :urls => ['/images', '/fonts'], :root => App.assets,
    :header_rules => [
      [:all, {'Cache-Control' => 'public, max-age=31536000'}],
      [:fonts, {'Access-Control-Allow-Origin' => '*'}]
    ]

  use Rack::Cache, :metastore => 'file:./tmp/cache/rack/meta', :entitystore => 'file:./tmp/cache/rack/body', :verbose => false unless %w[development test].include?(App.env)

  use Asset::Router
  use Rack::Session::Cookie, :path => '/', :secret => App.settings.cookie_secret
  use Rack::Flash
  use Rack::PostBodyContentTypeParser
  use Rack::JSONP
  use RequestStore::Middleware

  run App.new
end

run app
