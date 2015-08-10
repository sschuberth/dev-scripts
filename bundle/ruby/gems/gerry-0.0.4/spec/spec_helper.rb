require "rspec/expectations"
require 'webmock/rspec'

require_relative '../lib/gerry'

class MockGerry < Gerry::Client
  URL = 'http://localhost'
  
  def initialize
    super(URL)
  end
end

def get_fixture(filename)
  return '' if filename.empty?
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename)
  body = get_fixture(filename)
  stub_request(:get, "#{MockGerry::URL}#{url}").
    to_return(:status => 200, :body => "#{body}", :headers => {'Content-Type' => 'application/json'})
end

def stub_put(url, body, response_body=nil)
  response = {
    status: 200,
    headers: {
      'Content-Type' => 'application/json'
    },
    body: response_body
  }
  stub_request(:put, "#{MockGerry::URL}#{url}").
    with(:body => body, :headers => { 'Content-Type' => 'application/json' }).
      to_return(response)
end

def stub_post(url, body, response_body=nil)
  response = {
    status: 200,
    headers: {
      'Content-Type' => 'application/json'
    },
    body: response_body
  }
  stub_request(:post, "#{MockGerry::URL}#{url}").
    with(:body => body, :headers => { 'Content-Type' => 'application/json' }).
      to_return(response)
end