# frozen_string_literal: true

require_relative "lib/warning_signs/version"

Gem::Specification.new do |spec|
  spec.name = "warning_signs"
  spec.version = WarningSigns::VERSION
  spec.authors = ["Noel Rappin"]
  spec.email = ["noelrap@hey.com"]

  spec.summary = "A gem for managing ruby and rails deprecation warnings"
  spec.description = "A gem for managing ruby and rails deprecation warnings"
  spec.homepage = "https://github.com/noelrappin/warning_signs"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  spec.metadata = {
    "github_repo" => spec.homepage,
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"

  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "simplecov", "~> 0.17.0"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "awesome_print"
end
