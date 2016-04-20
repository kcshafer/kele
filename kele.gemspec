Gem::Specification.new do |s|
   s.name          = 'kele'
   s.version       = '0.0.1'
   s.date          = '2016-04-19'
   s.summary       = 'Kele API Client'
   s.description   = 'A client for the Bloc API'
   s.authors       = ['KC Shafer']
   s.email         = 'kclshafer@gmail.com'
   s.files         = `git ls-files`.split($/)
   s.require_paths = ["lib"]
   s.homepage      =
     'http://rubygems.org/gems/kele'
   s.license       = 'MIT'

   s.add_development_dependency "bundler", "~> 1.11"
   s.add_development_dependency "rake", "~> 10.0"
   s.add_development_dependency "rspec", "~> 3.0"
   s.add_development_dependency "webmock", "~> 1.24"
   s.add_runtime_dependency 'httparty', '~> 0.13'
end