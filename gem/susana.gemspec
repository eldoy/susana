Gem::Specification.new do |s|
  s.name        = 'susana'
  s.version     = '0.0.1'
  s.executables = ['susana']
  s.date        = '2017-07-13'
  s.summary     = "Susana ruby web application framework"
  s.description = "Light weight and fast web application framework. Everything you need to build apps and APIs."
  s.authors     = ["Fugroup Limited"]
  s.email       = 'vidar@fugroup.net'

  s.homepage    = 'https://github.com/fugroup/susana'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rack', '>= 0'
  s.add_development_dependency 'futest', '>= 0'

  s.require_paths = ['lib']
  s.files = ['lib/susana.rb']
end
