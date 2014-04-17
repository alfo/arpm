module ARPM
  class Package

    attr_accessor :name
    attr_accessor :author
    attr_accessor :versions
    attr_accessor :repository

    def initialize(opts = {})
      opts.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    # Search for a new package
    def self.search(name)

      # Grab the package list
      data = URI.parse("https://raw.githubusercontent.com/alfo/arpm-test/master/packages.json").read
      packages = JSON.parse(data)

      # Search the packages for one with the same name
      remote_package = packages.select { |p| p['name'] == name }

      # Did the search return any results?
      if remote_package.any?

        # It did, so grab the first (and only) package with that name
        remote_package = remote_package.first

        # Get a list of tags from the remote repo

        tags = Git::Lib.new.ls_remote(remote_package["repository"])["tags"]

        # Delete any tags that aren't version numbers
        tags.each { |t| tags.delete(t) unless t[0].is_number? }

        # Sort the tags newest to oldest
        versions = Hash[tags.sort.reverse]

        # Create a new package object and return it
        package = Package.new(:name => remote_package["name"],
                    :author => remote_package["author"],
                    :repository => remote_package["repository"],
                    :versions => versions)

      else
        # The package doesn't exist, so return false
        false
      end
    end

    def latest_version
      versions.keys.first.to_s
    end

    def install_path(version = nil)

      # Take the latest_version unless it's been specified
      version = latest_version unless version

      # Creat the install path
      path = ARPM::Config.base_directory + name

      # Arduino doesn't like dots or dashes in library names
      path = path + "_#{version.gsub('.', '_')}"

    end

    def register(version)
      ARPM::List.register(self, version)
    end

  end
end
