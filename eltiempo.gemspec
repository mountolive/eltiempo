
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "eltiempo/version"

Gem::Specification.new do |spec|
  spec.name          = "eltiempo"
  spec.version       = Eltiempo::VERSION
  spec.authors       = ["Leo Guercio"]
  spec.email         = ["lpguercio@gmail.com"]
  spec.platform      = Gem::Platform::Ruby

  spec.summary       = %q{eltiempo: Get weather information from different parts of the world}
  spec.description   = %q{eltiempo: 
                          Lets you know the average of the 
                          minimum and maximum temperature during the week,
                          and the temperature of the day for different parts of the world}
  spec.homepage      = "github.com/mountolive/eltiempo"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
