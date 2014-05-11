$:.push File.expand_path("../lib", __FILE__)
require "hexagonal_domain/version"

Gem::Specification.new do |s|
  s.name        = "hexagonal_domain"
  s.version     = HexagonalDomain::VERSION
  s.author      = "Andrew Kozin"
  s.email       = "andrew.kozin@gmail.com"
  s.summary     = "Hexagonal architecture domain model."
  s.description = "Declares base classes for Hexagonal architecture Domain models."
  s.homepage    = "https://github.com/nepalez/hexagonal_domain"
  s.license     = "MIT"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = "~> 2.1"

  s.files            = Dir["{app,lib}/**/*"]
  s.test_files       = Dir["spec/**/*", "Rakefile"]
  s.extra_rdoc_files = Dir["CHANGELOG.rdoc", "LICENSE", "README.rdoc"]

  s.add_runtime_dependency "activemodel", "~> 4.0"
  s.add_runtime_dependency "colorize",    "~> 0.7"
  s.add_runtime_dependency "virtus",      "~> 1.0"
  s.add_runtime_dependency "wisper",      "~> 1.3"

  s.add_development_dependency "rspec", "~> 2.14"
end
