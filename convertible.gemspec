require File.expand_path("../lib/convertible/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "convertible"
  s.version     = Convertible::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jens Kraemer"]
  s.email       = ["jk@jkraemer.net"]
  s.homepage    = "http://github.com/jkraemer/convertible"
  s.summary     = "client for the convertible.io online service"
  s.description = "convertible.io is a universal document conversion web service."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "convertible"

  # If you have other dependencies, add them here
  s.add_dependency "httparty", '~>0.7.8'

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["convertible"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
