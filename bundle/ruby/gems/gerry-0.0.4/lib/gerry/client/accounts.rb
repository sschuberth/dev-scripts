module Gerry
  class Client
    module Accounts
      # Get the global capabilities that are enabled for the calling user.
      #
      # @param [Array] options the query parameters.
      # @return [Hash] the account capabilities.
      def account_capabilities(options = [])
        url = '/accounts/self/capabilities'
        
        if options.empty?
          return get(url)
        end
        
        options = map_options(options)
        get("#{url}?#{options}")
      end

      # Get all groups that contain the specified account as a member
      #
      # @param [String] account_id the account
      # @return [Enumberable] the groups
      def groups_for_account(account_id)
        url = "/accounts/#{account_id}/groups/"
        get(url)
      end
    end
  end
end