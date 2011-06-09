require "bundler"
Bundler.setup

require 'rake/testtask'

desc 'Test the library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

gemspec = eval(File.read("convertible.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["convertible.gemspec"] do
  system "gem build convertible.gemspec"
  system "gem install convertible-#{convertible::VERSION}.gem"
end
