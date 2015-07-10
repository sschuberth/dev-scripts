require 'httparty'
require 'json'

module Gerry
  class Client
    include HTTParty
    headers 'Accept' => 'application/json'
    
    require_relative 'client/accounts'
    require_relative 'client/changes'
    require_relative 'client/groups'
    require_relative 'client/projects'
    require_relative 'client/request'
    
    include Accounts
    include Changes
    include Groups
    include Projects
    include Request
    
    def initialize(url, username = nil, password = nil)
      self.class.base_uri(url)
      
      if username && password      
        @username = username
        @password = password
      end
    end
  end
end