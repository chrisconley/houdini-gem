Gem::Specification.new do |s|
  s.name = %q{houdini}
  s.version = Houdini::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Conley"]
  s.description = %q{Rails 3 Engine for using the Houdini Mechanical Turk API}
  s.email = %q{chris@houdiniapi.com}

  s.files = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb']
  s.homepage = %q{http://github.com/chrisconley/houdini-gem}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Rails 3 Engine for using the Houdini Mechanical Turk API}

  s.add_runtime_dependency "rails", "~> 3.0.0"
  s.add_development_dependency "rspec-rails", ">= 2.5.0"
  s.add_development_dependency "capybara", ">= 0.4.1"
  s.add_development_dependency "sqlite3-ruby"
end

