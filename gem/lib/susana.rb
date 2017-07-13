# Susana ruby web application framework
# @homepage: https://github.com/fugroup/susana
# @author:   Vidar <vidar@fugroup.net>, Fugroup Ltd.
# @license:  MIT, contributions are welcome.

# This script downloads and installs your new application

require 'securerandom'

puts "\n * S U S A N A *\n\n"

# Get app name
name = ARGV[0].strip rescue nil

# Exit if app name not provided
if !name or name == ''
  puts "No app name provided. Usage: susana your_app_name\n\n"
  exit
end

# Get working dir
dir = Dir.pwd

# Install new susana app
`git clone https://github.com/fugroup/susana #{name}`

# Change working dir
Dir.chdir(name)

# Cleanup
`rm -rf .git`
`rm -rf gem`

# Create cookie secret
secret = SecureRandom::hex(26)

# Install secret
key = 'a8976c0df4fb8a28f8fe979270443d37f239cf8da8f1bf9734ba'
File.open('config.ru', 'w'){|f| f.write(File.read('config.ru').gsub(key, secret))}

puts "\nApp #{name} created, please review your settings in the config directory\n\n"
puts "To start the application, go to the #{name} directory and run 'puma'\n"
puts "Go to https://github.com/fugroup/susana for documentation\n\n"
