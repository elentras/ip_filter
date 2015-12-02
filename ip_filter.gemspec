require File.expand_path('../lib/ip_filter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ip_filter"
  gem.version       = IpFilter::VERSION
  gem.authors       = ["Jeremy Le Massu"]
  gem.email         = ["webmaster@elentras.com"]
  gem.summary       = "IP filter solution for Rails."
  gem.description   = "Filter ip by region/country/continent to grant access. Typically for DRM.\
  Based on Chris Trinh gem (https://github.com/elentras/ip_filter), I rewrite / review code and choose to keep this version under my own git account"
  gem.homepage      = "https://github.com/elentras/ip_filter"
  gem.files         = `git ls-files`.split("\n") - %w[ip_filter.gemspec Gemfile init.rb]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
end
