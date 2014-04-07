# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wordlelike/version'

Gem::Specification.new do |spec|
  spec.name          = 'wordlelike'
  spec.version       = Wordlelike::VERSION
  spec.authors       = ['Rob Styles']
  spec.email         = ['rob.styles@dynamicorange.com']
  spec.summary       = 'A small gem for drawing wordle style word clouds'
  spec.description   = spec.summary
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rmagick'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
