module ARPM
  class List

    def self.register(package, version)
      # Make sure the list exists
      FileUtils.touch(path) unless File.exists?(path)

      packages = JSON.parse(File.read(path)) rescue []

      list_package = packages.select { |p| p.keys[0] == package.name }

      # Is a version already installed?
      if list_package.any?

        # Yes it is, grab the first (and only)
        list_package = list_package.first

        # Is this version already installed?
        unless list_package[package.name].include?(version)

          # No it isn't, so add this version to the list
          list_package[package.name] << version

        end
      else

        # It hasn't so add the whole package
        packages << {package.name => [version]}
      end

      f = File.open(path, 'w')
      f.write(JSON.generate(packages, :quirks_mode => true))
      f.close

    end

    def self.path
      ARPM::Config.base_directory + "/arpm.txt"
    end

  end
end
