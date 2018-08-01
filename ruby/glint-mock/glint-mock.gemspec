# ruby files
ruby_files = Dir.glob('lib/**/*.rb') + Dir.glob('bin/**/*.rb')

# pre-defined Steps
features = Dir.glob('features/**/*.rb')

gem_files = ruby_files + features

Gem::Specification.new do |s|
  s.name = 'glint-mock'
  s.platform = Gem::Platform::RUBY
  s.version = '0.1.1'
  s.date = '2017-06-26'
  s.summary = 'Glint package'
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
  s.add_dependency('webrick', '1.3.1')
  s.add_dependency('json', '2.1.0')
end
