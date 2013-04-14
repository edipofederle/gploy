# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gploy/version'

Gem::Specification.new do |spec|
  spec.name          = "gploy"
  spec.version       = Gploy::VERSION
  spec.authors       = ["Edipo L Federle"]
  spec.email         = ["edipofederle@gmail.com"]
  spec.description   = %q{Deployment}
  spec.summary       = %q{Deployment with git}
  spec.homepage      = "http://github.com/edipofederle/gploy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "net-ssh", "~> 2.6.7"
  spec.add_development_dependency "net-sftp", "~> 2.1.1"
end