# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amor/version'

Gem::Specification.new do |spec|
  spec.name          = "amor"
  spec.version       = Amor::VERSION
  spec.authors       = ["Florian Dahms"]
  spec.email         = ["me@fdahms.com"]
  spec.summary       = "A versatile, yet simple modelling language for mathematical programming"
  spec.description   = "AMoR is a Ruby DSL for mathematical programming. It allows to simply define a mathematical program, but gives you all the features from Ruby for more complex projects"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
