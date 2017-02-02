# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cic_embeded_payment/version'

Gem::Specification.new do |spec|
  spec.name          = "cic_embeded_payment"
  spec.version       = CicEmbededPayment::VERSION
  spec.authors       = ["Angelo Delefortrie"]
  spec.email         = ["angelo.delefortrie@gmail.com"]

  spec.summary       = %q{Ruby lib to permit payments with cic embeded payment system}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/angelodlfrtr/ruby-cic-embeded-payment"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.8.0"
  spec.add_dependency "nokogiri", "~> 1.6.6.2"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
