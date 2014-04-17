require 'json'
require 'open-uri'

module ARPM
  class Package

    attr_accessor :name
    attr_accessor :author

    def initialize(opts={})
      opts.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    # Search for a new package
    def self.search(name)

      # Grab the package list
      data = URI.parse("https://raw.githubusercontent.com/alfo/arpm-test/master/packages.json").read
      packages = JSON.parse(data)

      # Search the packages for one with the same name
      package = packages.select { |p| p['name'] == name }

      # Did the search return any results?
      if package.any?

        # It did, so grab the first (and only) package with that name
        package = package.first

        # Get a list of tags from the remote repo
        tags = Git::Lib.new.ls_remote(package["repo"])["tags"]

        # Delete any tags that aren't version numbers
        tags.each { |t| tags.delete(t) unless t[0].is_number? }

        # Sort the tags newest to oldest
        versions = Hash[tags.sort.reverse]

        Package.new(:name => package["name"],
                    :author => package["author"],
                    :repo => package["repo"],
                    :versions => versions)
      else
        false
      end
    end
  end
end
