#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'gerry'
require 'set'

uri_str, *flags = ARGV
if uri_str.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri> [-u]"
    puts "Example : #{script} [user:password@]host[:port]"
    puts
    puts "     -u   List only unused groups (those that have no associated permissions)."
    exit
end

uri_str = 'https://' + uri_str unless uri_str.start_with?('https://', 'http://')
uri = URI.parse(uri_str)

uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

Gerry::Client.default_options.update(verify: false)
client = Gerry.new("#{uri.scheme}://#{uri.host}", uri.user, uri.password)

if flags.include?('-u')
    used_groups = Set.new

    client.projects.keys.each_slice(100) do |projects|
        client.access(projects).values.each do |info|
            info['local'].values.each do |permissions|
                permissions['permissions'].values.each do |info|
                    info['rules'].keys.each do |group|
                        used_groups.add(group)
                    end
                end
            end
        end
    end

    client.groups.each do |name, info|
        if !used_groups.include?(info['id'])
            puts name
        end
    end
else
    client.groups.keys.each do |name|
        puts name
    end
end
