module Gerry
  class Client
    module Projects
      # Get the projects accessible by the caller.
      #
      # @return [Hash] the projects.
      def projects
        get('/projects/')
      end

      # Get the projects that start with the specified prefix
      # and accessible by the caller.
      #
      # @param [String] name the project name.
      # @return [Hash] the projects.
      def find_project(name)
        get("/projects/#{name}")
      end

      # Get the symbolic HEAD ref for the specified project.
      #
      # @param [String] project the project name.
      # @return [String] the current ref to which HEAD points to.
      def get_head(project)
        get("/projects/#{project}/HEAD")
      end

      # Set the symbolic HEAD ref for the specified project to
      # point to the specified branch.
      #
      # @param [String] project the project name.
      # @param [String] branch the branch to point to.
      # @return [String] the new ref to which HEAD points to.
      def set_head(project, branch)
        url = "/projects/#{project}/HEAD"
        body = {
          ref: 'refs/heads/' + branch
        }
        put(url, body)
      end
    end
  end
end
