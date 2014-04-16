module ARPM
  class CLI < Thor

    desc "install", "Install a package"
    def install(name, version = nil)

      # Install all the things
      puts "Searching for packages...".magenta

      data = URI.parse("https://raw.githubusercontent.com/alfo/arpm-test/master/packages.json").read

      packages = JSON.parse(data)

      package = packages.select { |p| p['name'] == name }

      if package.any?

        path = File.expand_path("~/") + "/#{ARPM_HOME}/"

        puts "Cloning #{name} into ~/.arpm/"

        if (version)

        else

        end

      else
        puts "No package named #{name} found".red
      end

    end

  end
end
