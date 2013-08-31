lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/statsd/version'

Gem::Specification.new do |spec|
  spec.name          = 'sidekiq_statsd_middleware'
  spec.version       = Sidekiq::Statsd::VERSION
  spec.authors       = ['Tom Taylor']
  spec.email         = ['tom@newspaperclub.com']
  spec.homepage      = 'https://github.com/newspaperclub/sidekiq_statsd_middleware'
  spec.summary       = 'Server Middleware for Sidekiq to report metrics from workers to StatsD'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
