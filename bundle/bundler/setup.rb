require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
path = File.expand_path('..', __FILE__)
$:.unshift "#{path}/../#{ruby_engine}/gems/json-1.8.3/C/Users/seschube/Development/GitHub/dev-scripts/bundle/ruby/2.1.0/extensions/x64-mingw32/2.1.0/json-1.8.3"
$:.unshift "#{path}/../#{ruby_engine}/gems/json-1.8.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/gems/multi_xml-0.5.5/lib"
$:.unshift "#{path}/../#{ruby_engine}/gems/httparty-0.13.5/lib"
$:.unshift "#{path}/../#{ruby_engine}/gems/gerry-0.0.3/lib"
