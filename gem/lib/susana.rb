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
FileUtils.remove_dir(".git")
FileUtils.remove_dir("gem")

# Create cookie secret
secret = SecureRandom::hex(26)

# Install secret
key = 'a8976c0df4fb8a28f8fe979270443d37f239cf8da8f1bf9734ba'
file = File.read("config.ru").gsub(key, secret)
File.open("config.ru", 'w'){|f| f.write(file)}

puts "\nApp #{name} created, please review your settings in the config directory\n\n"
puts "To start the application:\n\n"
puts "cd #{name}"
puts "bundle install"
puts "puma\n\n"
puts "Go to https://github.com/fugroup/susana for documentation\n\n"
