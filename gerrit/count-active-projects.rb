#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'gerry'
require 'set'

uri_str, age = ARGV
if uri_str.nil? || age.nil?
    script = File.basename(__FILE__)
    puts <<EOT
Usage     : #{script} <uri> <age>
Example   : #{script} [user:password@]host[:port] 3mon

Rationale : Count the number of owners whose change(s) have been merged
            in the given age period backwards from now.
EOT
    exit(1)
end

uri_str = 'https://' + uri_str unless uri_str.start_with?('https://', 'http://')
uri = URI.parse(uri_str)

uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

Gerry::Client.default_options.update(verify: false)
client = Gerry.new("#{uri.scheme}://#{uri.host}", uri.user, uri.password)

projects = Set.new
changes = client.changes(["q=status:merged+-age:#{age}"])
changes.each do |change|
    projects << change['project']
end

puts "Number of active projects in the last #{age}: #{projects.size}"
