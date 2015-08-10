module Gerry
  class Client
    module Changes
      # Get changes visible to the caller.
      #
      # @param [Array] options the query parameters.
      # @return [Hash] the changes.
      def changes(options = [])
        url = '/changes/'
        
        if options.empty?
          return get(url)
        end
        
        options = map_options(options)
        get("#{url}?#{options}")        
      end
    end
  end
end