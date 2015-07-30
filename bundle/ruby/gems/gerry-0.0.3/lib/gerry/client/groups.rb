require 'json'

module Gerry
  class Client
    module Groups
      # Get all groups
      #
      # @return [Hash] the groups
      def groups
        url = '/groups/'
        get(url)
      end

      # Get all members for a group
      #
      # @param [Array] options the query parameters
      # @return [Array] the members
      def group_members(group_id, options = [])
        url = "/groups/#{group_id}/members/"

        if options.empty?
          return get(url)
        end

        options = map_options(options)
        get("#{url}?#{options}")
      end

      # Get the directly included groups of a group
      #
      # @return [Array] the included groups
      def included_groups(group_id)
        url = "/groups/#{group_id}/groups/"
        get(url)
      end

      # Create a new group
      #
      # @return [Hash] the group details
      def create_group(name, description, visible, owner_id=nil)
        url = "/groups/#{name}"
        body = {
          description: description,
          visible_to_all: visible,
        }
        body[:owner_id] = owner_id unless owner_id.nil? || owner_id.empty?
        put(url, body)
      end

      # Adds one or more users to a group
      #
      # @param [String] group_id the group id
      # @param [Enumberable] users the list of users identified by email address
      # @return [Hash] the account info details for each user added
      def add_to_group(group_id, users)
        url = "/groups/#{group_id}/members"
        body = {
          members: users
        }
        post(url, body)
      end

      def remove_from_group(group_id, users)
        url = "/groups/#{group_id}/members.delete"
        body = {
          members: users
        }
        post(url, body)
      end
    end
  end
end