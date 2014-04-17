module ARPM
  class Libfile

    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def dependencies

      packages = []

      content.gsub!(/\r\n?/, "\n")
      content.each_line do |line|

        if line.start_with('lib')
            elements = line.scan(/"([^"]*)"/) + line.scan(/'([^']*)'/)
            packages << {elements[0] => elements[1]}
        end

      end

      packages

    end

  end
end
