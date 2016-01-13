require 'cgi'

module Gerry
  class Client
    module Changes
      # Get changes visible to the caller.
      #
      # @param [Array] options the query parameters.
      # @return [Hash] the changes.
      def changes(options = [])
        endpoint = '/changes/'
        url = endpoint

        if !options.empty?
          url += '?' + map_options(options)
        end

        response = get(url)
        return response unless response.last.delete('_more_changes')

        # Get the original start parameter, if any, else start from 0.
        query = URI.parse(url).query
        query = query ? CGI.parse(query) : { 'S' => ['0'] }
        start = query['S'].join.to_i

        # Keep getting data until there are no more changes.
        loop do
          # Replace the start parameter, using the original start as an offset.
          query['S'] = ["#{start + response.size}"]
          url = endpoint + '?' + map_options(query)

          response.concat(get(url))
          return response unless response.last.delete('_more_changes')
        end
      end
    end
  end
end
