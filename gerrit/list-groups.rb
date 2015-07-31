#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'

require 'gerry'
require 'set'

uri_str, *flags = ARGV
if uri_str.nil?
    script = File.basename(__FILE__)
    puts "Usage   : #{script} <uri> [-u]"
    puts "Example : #{script} [user:password@]host[:port]"
    puts
    puts '     -u   List only unused groups (those that have no associated permissions'
    puts '          and are not inherited from).'
    exit
end

uri_str = 'https://' + uri_str unless uri_str.start_with?('https://', 'http://')
uri = URI.parse(uri_str)

uri.user = ENV['USER'] || ENV['USERNAME'] if uri.user.nil?
uri.password = ENV['GERRIT_HTTP_PASSWORD'] if uri.password.nil?

Gerry::Client.default_options.update(verify: false)
$server = uri.scheme + '://' + uri.host
$client = Gerry.new($server, uri.user, uri.password)

if flags.include?('-u')
    used_groups = Set.new

    STDERR.puts 'Determining groups that are used in permissions...'

    $client.projects.keys.each_slice(100) do |projects|
        $client.access(projects).values.each do |info|
            info['local'].values.each do |permissions|
                permissions['permissions'].values.each do |info|
                    info['rules'].keys.each do |group|
                        used_groups.add(group)
                    end
                end
            end
        end
    end

    STDERR.puts 'Determining groups that are being inherited from...'

    def get_included_group_ids(group_id)
        begin
            $client.included_groups(group_id).map do |group|
                group['id']
            end.to_set
        rescue Gerry::Client::Request::RequestError
            STDERR.puts "WARNING: Unable to get included groups for group '#{URI.decode(group_id)}'."
            Set.new
        end
    end

    def get_included_group_ids_recursive(group_id, parents = Set.new)
        children = get_included_group_ids(group_id)
        grandchildren = Set.new

        children.each do |id|
            if id == group_id
                STDERR.puts \
                    "WARNING:\n\n" \
                    "    #{$server}/#/admin/groups/uuid-#{group_id}\n\n" \
                    "includes itself.\n"
            elsif parents.include?(id)
                STDERR.puts \
                    "\nWARNING: Group #{$server}/#/admin/groups/uuid-#{group_id} " \
                    "includes its parent group #{$server}/#/admin/groups/uuid-#{id}.\n"
            else
                grandchildren.merge(get_included_group_ids_recursive(id, parents.add(group_id)))
            end
        end

        children.merge(grandchildren)
    end

    included_groups = Set.new
    used_groups.each do |id|
        if id.match('^[0-9a-f]{40}$')
            included_groups.merge(get_included_group_ids_recursive(id))
        end
    end
    used_groups.merge(included_groups)

    $client.groups.each do |name, info|
        if !used_groups.include?(info['id'])
            puts name
        end
    end
else
    $client.groups.keys.each do |name|
        puts name
    end
end
