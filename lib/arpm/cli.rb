require "fileutils"

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

        path = ARPM::Config.base_directory + name

        path = path + "-#{version}" if version

        puts "Cloning #{name} into #{path}"

        repo = Git.clone(package["repository"], path)

        tags = []
        repo.tags.each { |t| tags << t.name }

        if (version)

          if tags.include?(version)
            repo.checkout("tags/#{version}")
            puts "Installed #{name} Version #{version}".green.bold
          else
            File.rm_r(path)
            puts "#{name} Version #{version} does not exist".red
          end

        else

          tags.sort! { |x,y| y <=> x }
          tags.each { |t| tags.pop(e) unless e[0].is_number? }

          version = tags.first

          repo.checkout("tags/#{version}")
          puts "Installed #{name} Version #{version}".green.bold

        end

      else
        puts "No package named #{name} found".red
      end

    end

  end
end
