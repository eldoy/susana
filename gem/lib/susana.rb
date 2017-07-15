# Susana ruby web application framework
# @homepage: https://github.com/fugroup/susana
# @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
# @license:  MIT, contributions are welcome.

# This script downloads and installs your new application

require 'securerandom'
require 'fileutils'

puts "\n * S U S A N A *\n\n"

# Get app name
name = ARGV[0].strip rescue nil

# Exit if app name not provided
if !name or name == ''
  puts "No app name provided. Usage: susana your_app_name\n\n"
  exit
end

# Install new susana app
`git clone https://github.com/fugroup/susana #{name}`

FileUtils.cd(name)

# Cleanup
FileUtils.remove_dir('.git')
FileUtils.remove_dir('gem')

# Create cookie secret
secret = SecureRandom.hex(32)

# Install secret
key = '1eca29037f08b783cee7e77a958e01a4c7f2fa7dd9be61171709cf3e5f54ef65'
file = File.read('config.ru').gsub(key, secret)
File.open('config.ru', 'w'){|f| f.write(file)}

puts "\nApp #{name} created, please review your settings in the config directory\n\n"
puts "To start the application:\n\n"
puts "cd #{name}"
puts "bundle install"
puts "bundle exec puma\n\n"
puts "Open http://localhost:9292 in your browser. Enjoy!\n\n"
puts "Go to https://github.com/fugroup/susana for documentation\n\n"
