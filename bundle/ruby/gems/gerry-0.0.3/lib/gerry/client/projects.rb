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
    end
  end
end