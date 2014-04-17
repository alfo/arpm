module ARPM
  class Config

    def self.base_directory
      if OS.windows?
        lib_dir = "/My Documents/Arduino/libraries/"
      else OS.mac?
        lib_dir = "/Documents/Arduino/libraries/"
      end

      base = File.expand_path("~")

      "#{base}#{lib_dir}"
    end
  end
end
