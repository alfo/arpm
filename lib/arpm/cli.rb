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

        # Was the version specified?
        version = package.latest_version unless version

        package.install(version)

        puts "Installed #{name} version #{version}".green.bold

      else

        puts "No package named #{name} found".red
        return false

      end

    end

    desc "uninstall [PACKAGE] ([VERSION])", "Uninstall a package"
    def uninstall(name, version = nil)

      if ARPM::List.includes?(name)

        package = ARPM::Package.new(:name => name, :versions => ARPM::List.versions(name))

        versions = package.installed_versions

        # Was a version specified?
        if version

          # Yes it was, is it installed?
          if versions.include?(version)

            # Yes it is! Unintstall it
            package.uninstall(version)

            puts "#{package.name} version #{version} uninstalled".green.bold


          else

            # Nope, it's not installed
            puts "Version #{version} of #{name} is not installed".red and return
          end

        else

          if package.installed_versions.size > 1

            # They've got multiple installed but haven't said which one
            puts "Please specify a version to uninstall from this list:".red

            package.installed_versions.each do |v|
              puts "  #{v}"
            end

          else

            version = installed_versions.first

            # There's only one installed version
            package.uninstall(version)

            puts "#{package.name} version #{version} uninstalled".green.bold

          end

        end

      else

        puts "#{name} is not installed".red and return

      end

    end

    desc "update PACKAGE", "Update a package"
    def update(name)

      # Check to see if it is installed?
      if ARPM::List.includes?(name)

        # Get the current info
        package = ARPM::Package.search(name)

        # Does it exist?
        if package

          # Do we have more than one installed version?
          if package.installed_versions.size > 1

            # Yes, ask the user to deal with it
            puts "#{name} has more than one version installed:".red
            package.installed_versions.each do |v|
              puts "  #{v}"
            end
            puts "Please run" + "arpm install #{name}".bold + "to install the latest one"

          else

            # No, just one installed version

            current_version = package.installed_versions.first

            # Does this package even need updating?
            if current_version == package.latest_version

              # Nope
              puts "#{name} is already at the most recent version (#{package.latest_version})".red

            else

              # Yes, so let's actually fucking do it

              package.uninstall(current_version)
              package.install(package.latest_version)

              puts "#{name} updated to version #{package.latest_version}".green.bold

            end

          end

        else

          puts "#{name} no longer exists".red and return

        end

      else
        puts "#{name} is not installed yet".red and return
      end
    end

    desc "list", "List the installed packages"
    def list

      # Get a list of all the packages
      packages = ARPM::List.all

      puts "\nLocal Packages: \n".bold

      # Loop over them
      packages.each do |p|

        name = p.keys.first
        versions = p[name]

        # Print them out
        puts "#{name} (#{versions.join(', ')})".cyan

      end

      puts "\n"

    end

    desc "search [PACKAGE]", "Search for packages with names containing [PACKAGE]"
    def search(name)

      # Search for the package
      packages = ARPM::Package.search(name, false)

      if packages

        # Loop over any results
        packages.each do |package|
          puts "#{package.name}-#{package.latest_version}"
        end

      else
        puts "No results".red
      end
    end

    desc "bundle", "Install all a project's dependencies"
    def bundle

      # Find the Libfile
      lib_file = ARPM::Libfile.location

      if File.exists?(lib_file)

        # It exists, so get its contents and make an object
        lib_file = ARPM::Libfile.new(File.open(lib_file).read)

        # Loop over the dependencies
        lib_file.dependencies.each do |dependency|

          name = dependency.keys[0]
          version = dependency[dependency.keys[0]]

          # Make sure the package exists
          package = ARPM::Package.search(name)

          if package

            # Is it already installed?
            if ARPM::List.includes?(name, version)
              puts "Using #{name}-#{version}"
            else

              # No, so install it
              package.install(version)
            end
          else

            # The package doesn't exist
            puts "Could not find #{name}".red
          end

        end

      end

    end

  end
end
