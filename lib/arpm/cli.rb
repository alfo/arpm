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

          if package.installed_versions.size > 0

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
  end
end
