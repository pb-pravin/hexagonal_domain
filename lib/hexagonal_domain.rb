require "colorize"

lib = File.dirname(__FILE__)
Dir[File.join(lib, "hexagonal_domain", "**", "*.rb")].each{ |f| require f }

module HexagonalDomain
end
