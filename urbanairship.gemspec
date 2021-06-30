# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'urbanairship/version'

Gem::Specification.new do |spec|
  spec.name          = 'urbanairship'
  spec.version       = Urbanairship::VERSION
  spec.authors       = ['Airship']
  spec.email         = ['support@airship.com']
  spec.licenses      = ['Apache-2.0']

  spec.summary       = 'Ruby Gem for using the Airship API'
  spec.description   = 'A Ruby Library for using the Airship web service API for push notifications and rich app pages.'
  spec.homepage      = 'https://github.com/urbanairship/ruby-library'

  spec.required_ruby_version = '>= 2.0.0'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '>= 1.4', '< 4.0'

  spec.add_development_dependency 'bundler', '>= 1'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1'
  spec.add_development_dependency 'timecop'
end
