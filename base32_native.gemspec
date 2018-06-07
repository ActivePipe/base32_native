# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'base32_native/version'

Gem::Specification.new do |spec|
  spec.name          = "base32_native"
  spec.version       = Base32Native::VERSION
  spec.authors       = ["Nigel Sheridan-Smith"]
  spec.email         = ["nigel.sheridan-smith@activepipe.com"]

  spec.summary       = %q{Native C implementation of Base32 encode and decode}
  spec.description   = %q{Native C implementation of Base32 encode and decode}
  spec.homepage      = "https://github.com/ActivePipe/base32_native"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extensions << "ext/base32_native/extconf.rb"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 1.0.4"
  spec.add_development_dependency "rspec", "~> 3.0"
end
