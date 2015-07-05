Gem::Specification.new do |s|
  s.name        = 'rdio'
  s.version     = '0.2.0'
  s.date        = '2015-07-05'
  s.summary     = "Rdio API ruby wrapper"
  s.description = "Rdio API ruby wrapper"
  s.authors     = ["Daniel Cukier"]
  s.email       = 'danicuki@gmail.com'
  s.files       = ["lib/rdio.rb"]
  s.homepage    =
    'http://rubygems.org/gems/rdio'
  s.license       = 'MIT'
  s.add_runtime_dependency 'oauth'
  s.add_runtime_dependency 'rest-client'
end
