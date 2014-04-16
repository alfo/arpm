require "arpm/version"
require "arpm/string"

module ARPM
  class CLI < Thor

    desc "install", "Install a package"
    def install(name)

      # Install all the things
      p "Searching for packages...".blue

    end
  end
end
