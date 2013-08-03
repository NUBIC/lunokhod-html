# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lunokhod/html/version'

Gem::Specification.new do |spec|
  spec.name          = "lunokhod-html"
  spec.version       = Lunokhod::Html::VERSION
  spec.authors       = ["David Yip"]
  spec.email         = ["yipdw@member.fsf.org"]
  spec.description   = %q{Compiles Lunokhod survey DSLs to Javascript webapps}
  spec.summary       = %q{HTML/JS compiler for Lunokhod surveys}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
