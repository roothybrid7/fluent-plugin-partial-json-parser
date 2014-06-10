# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/partial_json_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-partial-json-parser"
  spec.version       = Fluent::PartialJSONParserPlugin::VERSION
  spec.authors       = ["Satoshi Ohki"]
  spec.email         = ["roothybrid7@gmail.com"]
  spec.summary       = %q{Fluentd ouput plugin to parse value with a JSON structure partial}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/roothybrid7/fluent-plugin-partial-json-parser"
  spec.license       = "Apache License v2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fluentd", "~> 0.10.39"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
