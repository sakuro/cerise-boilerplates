# frozen_string_literal: true

require_relative "lib/cerise/boilerplates/version"

Gem::Specification.new do |spec|
  spec.name = "cerise-boilerplates"
  spec.version = Cerise::Boilerplates::VERSION
  spec.authors = ["OZAWA Sakuro"]
  spec.email = ["10973+sakuro@users.noreply.github.com"]

  spec.summary = "Common setups."
  spec.description = "Generates / modifies typical boilerplate files."
  spec.homepage = "https://github.com/sakuro/cerise-boilerplates"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sakuro/cerise-boilerplates.git"
  spec.metadata["changelog_uri"] = "https://github.com/sakuro/cerise-boilerplates/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x|git ls-files -z|.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ spec/ .git .github Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "hanami-cli", "~> 2.1"
end
