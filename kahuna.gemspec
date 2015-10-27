# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kahuna/version'

Gem::Specification.new do |spec|
  spec.name          = "kahuna"
  spec.version       = Kahuna::VERSION
  spec.authors       = ["yeouchien"]
  spec.email         = ["yeouchien@gmail.com"]

  spec.summary       = %q{Ruby Kahuna API Client Library}
  spec.description   = %q{Simple ruby client interface to the Kahuna API.}
  spec.homepage      = "https://github.com/yeouchien/kahuna"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock", '>=1.22.1'
end
