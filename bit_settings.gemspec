# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bit_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "bit_settings"
  spec.version       = BitSettings::VERSION
  spec.authors       = ["pioz"]
  spec.email         = ["epilotto@gmx.com"]

  spec.summary       = %q{BitSettings is a plugin for ActiveRecord that transform a column of your model in a set of boolean settings.}
  spec.description   = %q{BitSettings is a plugin for ActiveRecord that transform a column of your model in a set of boolean settings.}
  spec.homepage      = "https://github.com/pioz/bit_settings"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.1.0"
  spec.add_development_dependency "rake", ">= 12.3"
  spec.add_development_dependency "sqlite3", ">= 1.3"
  spec.add_development_dependency "minitest", ">= 5.11"

  spec.add_dependency "activesupport", ">= 4.2.0"
  spec.add_dependency "activemodel", ">= 4.2.0"
  spec.add_dependency "activerecord", ">= 4.2.0"
end
