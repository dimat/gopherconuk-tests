# ruby files
ruby_files = Dir.glob('lib/**/*.rb') + Dir.glob('bin/**/*.rb')

# pre-defined Steps
features = Dir.glob('features/**/*.rb')

gem_files = ruby_files + features

Gem::Specification.new do |s|
  s.name = 'ready-checker'
  s.platform = Gem::Platform::RUBY
  s.version = '0.0.2'
  s.date = '2017-07-11'
  s.summary = 'Ready checks for tests'
  s.description = 'Test package'
  s.files = gem_files
  s.test_files = []
  s.authors = ['Dmitry Matyukhin']
  s.email = 'dmitry.matyukhin@glintpay.com'
  s.homepage = 'https://wwww.glintpay.com'
  s.license = 'Nonstandard'

  s.required_ruby_version = '>= 2.0'

  # Dependencies
  s.add_dependency('cucumber', '3.1.0')
end
