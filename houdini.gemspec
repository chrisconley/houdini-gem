$:.push File.expand_path("../lib", __FILE__)
require "houdini/version"

Gem::Specification.new do |s|
  s.name = %q{houdini}
  s.version = Houdini::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Chris Conley"]
  s.email = %q{chris@houdiniapi.com}
  s.summary = %q{Rails 3 Engine for using the Houdini Mechanical Turk API}
  s.description = %q{Rails 3 Engine for using the Houdini Mechanical Turk API}
  s.homepage = %q{http://github.com/chrisconley/houdini-gem}

  s.add_runtime_dependency "rails", "~> 3.0.0"
  s.add_development_dependency "rspec-rails", ">= 2.5.0"
  s.add_development_dependency "capybara", ">= 0.4.1"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "rake", "~> 0.8.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

