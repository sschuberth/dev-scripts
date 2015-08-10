require 'erb'

module Gerry
  class Client
    module Access
      # Get access rights for the specified project
      #
      # @param [VarArgs] projects the project names
      # @return [Hash] the list of access rights
      def access(*projects)
        projects = projects.flatten.map { |name| ERB::Util.url_encode(name) }
        url = "/access/?project=#{projects.join('&project=')}"
        get(url)
      end
    end
  end
end
