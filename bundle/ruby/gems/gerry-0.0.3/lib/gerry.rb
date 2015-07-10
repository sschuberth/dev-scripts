require_relative 'gerry/client'

module Gerry
  class << self  
    # Alias for Gerry::Client.new
    #
    # @return [Gerry::Client]
    def new(url, username = nil, password = nil)
      Gerry::Client.new(url, username, password)
    end
  end
end