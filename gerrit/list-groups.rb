#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'net/https'
require 'net/http/digest_auth'
require 'json'

host, flag = ARGV
if host.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri>"
    puts "Example : #{script} [user:password@]host[:port]"
    exit
end

host = 'https://' + host unless host.start_with?('https://', 'http://')
uri = URI.parse("#{host}/a/groups/")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.class == URI::HTTPS)
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Authenticate
get_request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(get_request)

if response.code.to_i == 401
    uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
    uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

    if uri.user.nil? or uri.password.nil?
        puts 'Error: Please specify a user and password as part of the URI.'
        exit
    end

    www_auth = response['www-authenticate']

    www_auth_split = www_auth.split(',').map do |item|
        item.split('=')
    end
    www_auth_split.flatten!.map! do |item|
        item.strip
    end
    puts 'Authenticating ' + Hash[*www_auth_split]['Digest realm'] + ' with user ' + uri.user + '...'

    digest_auth = Net::HTTP::DigestAuth.new
    get_auth = digest_auth.auth_header(uri, www_auth, 'GET')
end

# Execute
get_request = Net::HTTP::Get.new(uri.request_uri)
get_request.add_field('Authorization', get_auth) if defined? get_auth

response = http.request(get_request)

if response.code.to_i == 200
    # We need to strip the magic prefix from the first line of the response, see
    # https://gerrit-review.googlesource.com/Documentation/rest-api.html#output.
    groups = JSON.parse(response.body.sub!(/^\)\]\}'$/, ''))
    groups.keys.each do |name|
        puts name
    end
else
    puts 'Error getting the list of groups: ' + response.message + '.'
end
