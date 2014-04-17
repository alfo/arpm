module ARPM
  class List

    def self.register(package, version)
      # Make sure the list exists
      FileUtils.touch(path) unless File.exists?(path)

      packages = JSON.parse(File.read(path))

      # Is this package and version already registered?
      unless packages.include?(package.name) and packages[package.name]["version"] == version

        packages << package

        f = File.open(path)
        f.write(JSON.generate(packages, quirks_mode: true))
        f.close

      end

    end

    def self.path
      ARPM::Config.base_directory + "/.arpm"
    end

  end
end
