# -*- encoding: utf-8 -*-

require File.expand_path('../lib/pushradar/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "pushradar"
  s.version = PushRadar::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["PushRadar"]
  s.email = ["contact@pushradar.com"]
  s.homepage = "https://github.com/PushRadar/pushradar-server-ruby"
  s.summary = %q{PushRadar Ruby server library}
  s.description = %q{PushRadar's official Ruby server library}
  s.license = "MIT"

  s.add_dependency "multi_json", "~> 1.15"
  s.add_dependency "httpclient", "~> 2.8"
  s.add_dependency "json", "~> 2.3"

  s.add_development_dependency "rake", "~> 13.0"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end