#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'gerry'

uri_str, flag = ARGV
if uri_str.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri>"
    puts "Example : #{script} [user:password@]host[:port]"
    exit
end

uri_str = 'https://' + uri_str unless uri_str.start_with?('https://', 'http://')
uri = URI.parse(uri_str)

uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

Gerry::Client.default_options.update(verify: false)
client = Gerry.new("#{uri.scheme}://#{uri.host}", uri.user, uri.password)

client.groups.keys.each do |name|
    puts name
end
