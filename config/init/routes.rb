# Load routes
App.routes = {}

Dir['./app/routes/*.yml'].sort.each do |f|

  # Load route file
  r = YAML.load_file(f)

  # Remove invalid
  r.keep_if{|k, v| k =~ /\w+#\w+/}

  r.each do |k, v|

    r[k].reverse_merge!('method' => 'GET', 'before' => [], 'filters' => [], 'validations' => [], 'after' => [])
    r[k]['method'].upcase!

    # Use regex by prefixing r!
    path = r[k]['path']
    r[k]['path'] = %r{#{path[2..-1]}} if path.start_with?('r!')
  end
  App.routes.merge!(r)
end

# Load lookup map
App.map = Hash.new{|h, k| h[k] = []}

# Load routes and precompile route matcher
App.routes.each do |k, v|
  App.map[v['method']] << [Mustermann.new(v['path'])] + k.split('#')
end
