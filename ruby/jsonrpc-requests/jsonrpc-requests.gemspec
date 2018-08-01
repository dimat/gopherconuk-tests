# ruby files
ruby_files = Dir.glob('lib/**/*.rb') + Dir.glob('bin/**/*.rb')

# pre-defined Steps
features = Dir.glob('features/**/*.rb')

gem_files = ruby_files + features

Gem::Specification.new do |s|
  s.name = 'jsonrpc-requests'
  s.platform = Gem::Platform::RUBY
  s.version = '0.0.6'
  s.date = '2017-08-14'
  s.summary = 'Interface to the jsonrpc'
  s.description = 'Interface to the jsonrpc'
  s.files = gem_files
  s.require_paths = ['lib', 'features/step_definitions']
  s.test_files = []
  s.authors = ['Italo Cadamuro']
  s.email = 'Italo.Cadamuro@glintpay.com'
  s.homepage = 'https://wwww.glintpay.com'
  s.license = 'Nonstandard'

  s.required_ruby_version = '>= 2.0'

  # Dependencies
  s.add_dependency('cucumber', '3.1.0')
end
