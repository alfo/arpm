require "fileutils"

module ARPM
  class CLI < Thor

    desc "install", "Install a package"
    def install(name, version = nil)

      # Install all the things
      puts "Searching for packages...".cyan

      data = URI.parse("https://raw.githubusercontent.com/alfo/arpm-test/master/packages.json").read

      packages = JSON.parse(data)

      package = packages.select { |p| p['name'] == name }

      if package.any?

        path = ARPM::Config.base_directory + name

        path = path + "_#{version.gsub('.', '_')}" if version

        puts "Cloning #{name} into #{path}"

        FileUtils.rm_r(path) if File.exists?(path)
        repo = Git.clone(package.first["repository"], path)

        tags = []
        repo.tags.each { |t| tags << t.name }

        puts "No releases of #{name} yet".red and return unless tags.any?

        if (version)

          if tags.include?(version)
            repo.checkout("tags/#{version}")
            puts "Installed #{name} version #{version}".green.bold
          else
            FileUtils.rm_r(path)
            puts "#{name} version #{version} does not exist".red
          end

        else

          tags.sort! { |x,y| y <=> x }
          tags.each { |t| tags.pop(t) unless t[0].is_number? }

          version = tags.first

          repo.checkout("tags/#{version}")

          FileUtils.mv(path, "#{path}_#{version.gsub('.', '_')}")

          puts "Installed #{name} Version #{version}".green.bold

        end

      else
        puts "No package named #{name} found".red
      end

    end

  end
end
