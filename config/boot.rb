# encoding: UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Set up env
env = ENV['RACK_ENV'] || 'development'
stats = env == 'development'

# Print welcome message and setup stats
if stats
  puts %{\n * S U S A N A *}

  # Recording boot time
  t = Time.now

  # Bundler setup: https://git.io/vXbws
  $bundle_timer = false
end

require 'bundler/setup'
groups = [:default]
groups << :test if env == 'test'
groups << :development if env == 'development'
Bundler.require(*groups)

autoload :SuckerPunch, 'sucker_punch'
autoload :Asset, 'asset'

# Active support
require 'active_support'
require 'active_support/core_ext'

# Add dot syntax to Hash
Hash.use_dot_syntax = true

# Ruby libs
require 'pp'
require 'uri'
require 'time'
require 'json'
require 'set'
require 'net/http'
require 'net/https'
require 'rexml/document'
require 'erb'
autoload :CGI, 'cgi'

# Record time required to load gems
if stats
  t2 = Time.now
  puts "\n Load gems: #{(t2 - t).round(3)}"
end

# Load app
require './app.rb'

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
App.settings = YAML.load_file('./config/settings.yml') || {}

# Locale setup
require 'i18n/backend/fallbacks'
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.load_path = Dir[File.join(App.root, 'config', 'locales', '*.yml')]
I18n.backend.load_translations
I18n.default_locale = :en

# Set up available regex
App.regex = {

  # Add language in front of the path to translate
  :locale => %r{^\/(#{(I18n.available_locales - [I18n.default_locale]).join('|')})},

  # Image regexp, full url including protocol
  :image => /http[s]?:\/\/.+(\.(jpg|jpeg|png|gif|bmp))$/i,

  # Image regexp, just extension
  :extimage => /^.+(\.(jpg|jpeg|png|gif|bmp))$/i,

  # Vimeo video urls
  :vimeo => /http[s]?:\/\/(www\.)?vimeo.com\/(\d+)/,

  # Youtube video urls
  :youtube => /http[s]?:\/\/(www\.)?(youtu.be\/|youtube.com\/watch\?v=)(\S+)/,

  # Facebook video urls
  :facebook => /http[s]?:\/\/((www|web|m)\.)?facebook.com\/[A-z0-9]{2,}\/videos\/(\d+)\/?/,

  # Email address
  :email => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,16}\z/,

  # Integer
  :int => /^\d+$/,

  # Float
  :float => /^(\d*[.])?\d+$/
}

# Load database settings
App.database = (YAML.load_file('./config/database.yml') || {})[App.env]

# Connect database
if App.database

  # Read settings or load defaults
  uri = "#{App.database['url'] || 'localhost'}:#{App.database['port'] || 27017}"
  name = "#{App.database['name'] || App.name}_#{App.env}"

  # Set up logger
  # Mongo::Logger.logger.level = ::Logger::INFO
  Mongo::Logger.logger.level = ::Logger::FATAL if App.env == 'development'

  # Change these to write to log file
  # Mongo::Logger.logger = ::Logger.new('./log/mongo.log')

  # Connect
  Minimongo.db = Mongo::Client.new([uri], :database => name)

  # Access db from $db
  $db = include(Minimongo::Query)
else
  puts "Database settings not found for #{App.env} in config/database.yml"
end

# Helper to get class name from file name
def klass(f); f.split('/').last[0..-4].camelize; end

# Data
Dir['./config/data/*.rb'].sort.each{|f| require f}

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

# Load routes
App.routes = {}

Dir['./app/routes/*.yml'].sort.each do |f|
  r = YAML.load_file(f)
  r.each do |k, v|
    r[k].reverse_merge!('method' => 'GET', 'filters' => [], 'validations' => [])
    r[k]['method'].upcase!
  end
  App.routes.merge!(r)
end

# Load lookup map
App.map = {'GET' => [], 'POST' => []}

App.routes.each do |k, v|
  App.map[v['method']] << [Mustermann.new(v['path'])] + k.split('#')
end

# Record time required to load the app files
if stats
  t3 = Time.now
  puts " Load code: #{(t3 - t2).round(3)}"
  puts " Load done: #{(t3 - t).round(3)}\n\n"
end

# Console
$web ||= false
unless $web
  # Add your console statements here
  # Start a console with irb -r ./config/boot.rb
  # Alias in your shell: alias console="irb -r ./config/boot.rb"
end

# Listen for file changes
if env == 'development'
  listener = Listen.to(App.root) do |m, a, r|
    # puts "M: #{m}\nA: #{a}\nR: #{r}"
    (m + a + r).each do |f|
      case File.extname(f)
      when '.rb'
        $LOADED_FEATURES.delete(f)
        require f unless r.include?(f)
      when '.yml'
      end
    end
  end
  listener.start
end
