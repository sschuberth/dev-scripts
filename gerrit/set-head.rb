#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'net/https'
require 'net/http/digest_auth'
require 'json'

host, project, branch = ARGV
if host.nil? or project.nil? or branch.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri> <project> <branch>"
    puts "Example : #{script} user:password@host android master"
    exit
end

uri = URI.parse("https://#{host}/a/projects/#{project}/HEAD")
uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

if uri.user.nil? or uri.password.nil?
    puts 'Error: Please specify a user and password as part of the URI.'
    exit
end

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.class == URI::HTTPS)
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Authenticate
get_request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(get_request)

if response.code.to_i == 401
    www_auth = response['www-authenticate']

    www_auth_split = www_auth.split(',').map do |item|
        item.split('=')
    end
    www_auth_split.flatten!.map! do |item|
        item.strip
    end
    puts 'Authenticating ' + Hash[*www_auth_split]['Digest realm'] + ' with user ' + uri.user + '...'

    digest_auth = Net::HTTP::DigestAuth.new
    put_auth = digest_auth.auth_header(uri, www_auth, 'PUT')
end

# Execute
put_request = Net::HTTP::Put.new(uri.request_uri, { 'Content-Type' => 'application/json' })
put_request.add_field('Authorization', put_auth)

HEAD = { :ref => 'refs/heads/' + branch }
put_request.body = HEAD.to_json

response = http.request(put_request)

if response.code.to_i == 200
    puts 'Successfully set HEAD to ' + branch + '.'
else
    puts 'Error setting HEAD to ' + branch + ': ' + response.message + '.'
end
