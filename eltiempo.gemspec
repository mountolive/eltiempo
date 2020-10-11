
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "eltiempo/version"

Gem::Specification.new do |spec|
  spec.name          = "eltiempo"
  spec.version       = Eltiempo::VERSION
  spec.authors       = ["Leo Guercio"]
  spec.email         = ["lpguercio@gmail.com"]
  spec.platform      = Gem::Platform::RUBY

  spec.summary       = %q{eltiempo: Get weather information from different cities in Barcelona (Spain)}
  spec.description   = %q{eltiempo: 
                          Lets you know the average of the 
                          minimum and maximum temperature for the next 7 days,
                          and the temperature of the current day 
                          for different cities in Barcelona (Spain)}
  spec.homepage      = "https://github.com/mountolive/eltiempo"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.2"
  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "rspec", "~> 3.9.0"
  spec.add_development_dependency "vcr", "~> 6.0.0"
  spec.add_development_dependency "nokogiri", "~> 1.10.10"
  spec.add_development_dependency "dotenv", "~> 2.7.0"
  spec.add_development_dependency "simplecov", "~> 0.19.0"
  spec.add_development_dependency "webmock", "~> 3.9.1"
end
