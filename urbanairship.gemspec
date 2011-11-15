require 'rake'

Gem::Specification.new do |s|
  s.name = 'urbanairship'
  s.version = '1.0.3'
  s.date = '2011-11-14'
  s.summary = 'A Ruby wrapper for the Urbanairship API'
  s.description = 'Urbanairship is a Ruby library for interacting with the Urbanairship (http://urbanairship.com) API.'
  s.homepage = 'http://github.com/groupon/urbanairship'
  s.authors = ['Groupon, Inc.']
  s.email = ['rubygems@groupon.com']
  s.files = FileList['README.markdown', 'LICENSE', 'Rakefile', 'lib/**/*.rb'].to_a
  s.test_files = FileList['spec/**/*.rb'].to_a

  s.add_dependency 'json'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'

  s.required_ruby_version = '>= 1.8.6'
end
