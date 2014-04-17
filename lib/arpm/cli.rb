require "fileutils"

module ARPM
  class CLI < Thor

    desc "install", "Install a package"
    def install(name, version = nil)

      # Install all the things
      puts "Searching for packages...".cyan

      package = ARPM::Package.search(name)

      if package

        # Check to see if there actually any releases yet
        puts "No releases of #{name} yet".red and return unless package.latest_version

        # Check that the requested version exists
        if version and !package.versions.include(version)
          puts "Version #{version} of #{name} doesn't exist".red and return
        end

        # Get the install path
        path = package.install_path(version)

        puts "Cloning #{name} into #{path}"

        # Delete the path if it already exists
        FileUtils.rm_r(path) if File.exists?(path)

        # Clone the repository!
        repo = Git.clone(package.first["repository"], path)

        # Was the version specified?
        if version

          # It does, so checkout the right version
          repo.checkout("tags/#{version}")
          puts "Installed #{name} version #{version}".green.bold

        else

          # It does, so checkout the right version
          repo.checkout("tags/#{package.latest_version}")
          puts "Installed #{name} version #{version}".green.bold

        end

      else
        puts "No package named #{name} found".red
      end

    end

  end
end
