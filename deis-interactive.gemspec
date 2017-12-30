# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deis-interactive/version'

Gem::Specification.new do |spec|
  spec.name          = "deis-interactive"
  spec.version       = RedisTest::VERSION
  spec.authors       = ["Phuong Nguyen"]
  spec.email         = ["phuongnd08@gmail.com"]
  spec.description   = %q{A helper to launch redis server during test}
  spec.summary       = %q{A helper to launch redis server during test}
  spec.homepage      = "https://github.com/phuongnd08/deis-interactive"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "thor"
end
