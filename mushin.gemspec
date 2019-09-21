# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mushin/version'

Gem::Specification.new do |spec|
  spec.name          = "mushin"
  spec.version       = Mushin::VERSION
  spec.authors       = ["zotherstupidguy"]
  spec.email         = ["zotherstupidguy@gmail.com"]

  spec.summary       = %q{mushin is a domain-specific framwork generator}
  spec.description   = %q{mushin allows you to generate domain-specific frameworks and domain extenstions.}
  spec.homepage      = "http://mushin-rb.github.io/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "ibsciss-middleware", "~> 0.3"
  spec.add_runtime_dependency "ibsciss-middleware", "~> 0.3"

  spec.add_development_dependency "thor" #, "~> 0.3"
  spec.add_runtime_dependency "thor" #, "~> 0.3"

  #spec.add_runtime_dependency "sinatra" #, "~> 0.3"
  spec.add_runtime_dependency "ssd" #, "~> 0.3"
  #spec.add_runtime_dependency "cinch" #, "~> 0.3"

  # favouring ore for gem generation over bundler, as it providers a fine-grained customization
  #spec.add_runtime_dependency 'ore' #, '~> 0.3'

  #spec.add_runtime_dependency 'logger-colors', '~> 1.0'


  #TODO http://guides.rubygems.org/security/
end
