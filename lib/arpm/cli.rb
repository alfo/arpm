require "fileutils"

module ARPM
  class CLI < Thor

    desc "install [PACKAGE] ([VERSION])", "Install a package"
    def install(name, version = nil)

      # Install all the things
      puts "Searching for packages...".cyan

      package = ARPM::Package.search(name)

      if package

        # Check to see if there actually any releases yet
        puts "No releases of #{name} yet".red and return unless package.latest_version

        # Check that the requested version exists
        if version and !package.versions.include?(version)
          puts "Version #{version} of #{name} doesn't exist".red
          return false
        end

        # Get the install path
        path = package.install_path(version)

        puts "Cloning #{name} into #{path}"

        # Delete the path if it already exists
        FileUtils.rm_r(path) if File.exists?(path)

        # Clone the repository!
        repo = Git.clone(package.repository, path)

        # Was the version specified?
        version = package.latest_version unless version

        # It does, so checkout the right version
        repo.checkout("tags/#{version}")

        # Register the package to the list
        package.register(version)

        puts "Installed #{name} version #{version}".green.bold

      else

        puts "No package named #{name} found".red
        return false

      end

    end

    desc "uninstall [PACKAGE] ([VERSION])", "Uninstall a package"
    def uninstall(name, version = nil)
      package = ARPM::Package.search(name)
      if package

      else
        puts "No package named #{name} found".red
        return false
      end
    end
  end
end
