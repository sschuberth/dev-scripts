#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'gerry'

uri_str, project, branch = ARGV
if uri_str.nil? or project.nil? or branch.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri> <project> <branch>"
    puts "Example : #{script} [user:password@]host[:port] android master"
    exit
end

uri_str = 'https://' + uri_str unless uri_str.start_with?('https://', 'http://')
uri = URI.parse(uri_str)

uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

Gerry::Client.default_options.update(verify: false)
client = Gerry.new("#{uri.scheme}://#{uri.host}", uri.user, uri.password)

puts 'HEAD now points to ' + client.set_head(project, branch)
