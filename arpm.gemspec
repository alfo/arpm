# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arpm/version'
require 'arpm/string'

Gem::Specification.new do |spec|
  spec.name          = "arpm"
  spec.version       = ARPM::VERSION
  spec.authors       = ["Alex Forey"]
  spec.email         = ["me@alexforey.com"]
  spec.summary       = %q{The Arduino Package Manager}
  spec.description   = %q{Keep your libraries in shape}
  spec.homepage      = "http://arpm.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["arpm"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "colorize", "~> 0.7"
  spec.add_runtime_dependency "git", "~> 1.2.6"
end
