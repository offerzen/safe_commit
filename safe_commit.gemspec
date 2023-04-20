# frozen_string_literal: true

require_relative "lib/safe_commit/version"

Gem::Specification.new do |spec|
  spec.name = "safe_commit"
  spec.version = SafeCommit::VERSION
  spec.authors = ["nic"]
  spec.email = ["nic@offerzen.com"]

  spec.summary = "Ruby DSL for pre-commit checks"
  spec.homepage = "https://www.offerzen.com"
  spec.license = "MIT"
  spec.required_ruby_version = "~> 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.offerzen.com"
  spec.metadata["changelog_uri"] = "https://www.offerzen.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "rubocop", "~> 1.21"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
