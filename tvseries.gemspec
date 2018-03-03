lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tvseries/version'

Gem::Specification.new do |spec|
  spec.name          = 'tvseries'
  spec.version       = TVSeries::VERSION
  spec.authors       = ['Athitya Kumar']
  spec.email         = ['athityakumar@gmail.com']
  spec.summary       = "A Ruby CLI gem that scrapes TV Series information from various sources, and builds web-view."
  spec.homepage      = 'https://github.com/athityakumar/tvseries'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = 'tvseries'
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mechanize'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'rubygems-tasks'
end
