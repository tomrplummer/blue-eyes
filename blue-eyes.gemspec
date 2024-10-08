# blue_eyes.gemspec
Gem::Specification.new do |spec|
  spec.name          = "blue-eyes"
  spec.version       = "0.2.0"
  spec.authors       = ["Tom Plummer"]
  spec.email         = ["tom.plummer@hey.com"]

  spec.summary       = %q{A Ruby-based project generator for Sinatra applications.}
  spec.description   = %q{BlueEyes generates project scaffolding tailored for Sinatra, incorporating best practices and optional configurations for HAML, Sequel, and TailwindCSS.}
  spec.license       = "MIT"

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.files = Dir.glob(["bin/*", "lib/**/*", "templates/**/*", ".templates/db/migrations", ".templates/app/models"])

  spec.bindir        = "bin"
  spec.executables   = 'blue-eyes'
  spec.require_paths = ["lib", "templates"]

  # Since the script itself doesn't use external gems, we might not list runtime dependencies here.
  # Only list gems if your script directly requires them to run.

  # Runtime dependencies
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "toml-rb"

  # Development dependencies
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"

  # Metadata
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  # spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tomrplummer/blue_eyes"
  # spec.metadata["changelog_uri"] = "https://github.com/USERNAME/blue_eyes/CHANGELOG.md"
end
