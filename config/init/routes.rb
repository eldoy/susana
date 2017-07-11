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
