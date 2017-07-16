# Load routes

test 'routes'

# Load routes
ROUTES = {}

Dir['./app/routes/*.yml'].sort.each do |f|
  r = YAML.load_file(f)
  r.each do |k, v|
    puts "KEY: #{k}"
    r[k].reverse_merge!('method' => 'GET', 'filters' => [], 'validations' => [])
    r[k]['method'].upcase!
  end
  ROUTES.merge!(r)
end

puts ROUTES
puts ROUTES.keys


# Load lookup map
MAP = {'GET' => [], 'POST' => []}

ROUTES.each do |k, v|
  puts "K: #{k}"
  puts "V: #{v}"
  MAP[v['method']] << [Mustermann.new(v['path'])] + k.split('#')
end

puts MAP

# Match a route
params = nil
route = MAP['GET'].find{|r| params = r[0].params('/login')}

if route
  puts "FOUND: #{route[1]}##{route[2]} - #{params.inspect}"
else
  puts "NOT FOUND!"
end

# Match a route
params = nil
route = MAP['GET'].find{|r| params = r[0].params('/')}

if route
  puts "FOUND: #{route[1]}##{route[2]} - #{params.inspect}"
else
  puts "NOT FOUND!"
end

# Match a route
params = nil
route = MAP['GET'].find{|r| params = r[0].params('/fu')}

if route
  puts "FOUND: #{route[1]}##{route[2]} - #{params.inspect}"
else
  puts "NOT FOUND!"
end

# Match a route
params = nil
route = MAP['GET'].find{|r| params = r[0].params('/user/fu')}

if route
  puts "FOUND: #{route[1]}##{route[2]} - #{params.inspect}"
else
  puts "NOT FOUND!"
end

# Match a route
params = nil
route = MAP['POST'].find{|r| params = r[0].params('/user/fu')}

if route
  puts "FOUND: #{route[1]}##{route[2]} - #{params.inspect}"
else
  puts "NOT FOUND!"
end

# root#home:
#   desc: Application root
#   method: get
#   path: '/'
#   filters: []
#   validations: []
