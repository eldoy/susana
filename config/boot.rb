# encoding: UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Set to true if running web server
$web ||= false

# Set up env
env = ENV['RACK_ENV'] || 'development'

# Set up stats and print welcome message
require './lib/susana/stats.rb'
stats = Susana::Stats.new(env).tap(&:welcome)

# Require gems
require 'bundler/setup'
groups = [:default]
groups << :test if env == 'test'
groups << :development if env == 'development'
Bundler.require(*groups)

# Active support
require 'active_support'
require 'active_support/core_ext'

# Autoload gems
autoload :Asset, 'asset'
autoload :Pushfile, 'pushfile'
autoload :Mongo, 'mongo'
autoload :Easymongo, 'easymongo'
autoload :SuckerPunch, 'sucker_punch'
autoload :SitemapGenerator, 'sitemap_generator'
autoload :Mustermann, 'mustermann'
autoload :Tilt, 'tilt'
autoload :Erubis, 'erubis'
autoload :RequestStore, 'request_store'
autoload :UTF8Cleaner, 'utf8-cleaner'

# Record time required to load gems
stats.gems

# Load susana
Dir['./lib/susana/*.rb'].sort.each{|f| require f}

# Set app enviroment
App.env = env

# Enable debug
App.debug = false

# Store directories
App.root = Dir.pwd
App.name = App.root.split('/')[-1]
App.views = File.join(App.root, 'app', 'views')
App.assets = File.join(App.root, 'app', 'assets')

# Load settings
App.settings = (YAML.load_file('./config/settings.yml') || {}).to_dot

# Set up available regex
App.regex = Susana::Regex.new

# Set up mail
App.mail = Susana::Mail.new

# Set up sitemap and write
App.sitemap = Susana::Sitemap.new

# Uncomment to always write sitemap on startup
# App.sitemap.write if env == 'production' and $web

# Uncomment to always ping search engines
# App.sitemap.ping if env == 'production' and $web

# Helper to get class name from file name
def klass(f); f.split('/').last[0..-4].camelize; end

# Init
Dir['./config/init/*.rb'].sort.each{|f| require f}

# Extensions
Dir['./config/extensions/*.rb'].sort.each{|f| require f}

# Lib files
Dir['./lib/tools/*.rb'].sort.each{|f| require f}
Dir['./lib/jobs/*.rb'].sort.each{|f| autoload klass(f).to_sym, f}
Dir['./lib/middleware/*.rb'].sort.each{|f| require f}
Dir['./lib/*.rb'].sort.each{|f| require f}

# App files
Dir['./app/models/*.rb'].sort.each{|f| require f}
Dir['./app/controllers/*.rb'].sort.each{|f| require f}
Dir['./app/helpers/*.rb'].sort.each{|f| require f}
Dir['./app/validations/*.rb'].sort.each{|f| require f}
Dir['./app/filters/*.rb'].sort.each{|f| require f}

# Include helpers, validations and filters
Dir['./app/{helpers,validations,filters}/*.rb'].sort.each do |f|
  ApplicationController.include(Object.const_get(klass(f)))
end

# Record time required to load the app files
stats.app

# Console
unless $web
  # Add your console statements here
  # Start a console with irb -r ./config/boot.rb
  # Alias in your shell: alias console="irb -r ./config/boot.rb"
end
