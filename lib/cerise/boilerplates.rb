# frozen_string_literal: true

require "hanami/cli"
require "zeitwerk"

module Cerise
  module Boilerplates
    class Error < StandardError; end

    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "cerise-boilerplates"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/cerise-boilerplates.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/cerise-boilerplates.rb",
          "#{root}/cerise/boilerplates/version.rb"
        )
      end
    end

    gem_loader.setup
    require_relative "boilerplates/version"

    if Hanami::CLI.within_hanami_app?
      Hanami::CLI.after "install", Commands::Rake::Install
      Hanami::CLI.after "install", Commands::Rubocop::Install
      Hanami::CLI.after "install", Commands::Persistence::Install
      Hanami::CLI.after "install", Commands::Session::Install
      # Hanami::CLI.after "install", Commands::Operation::Install
      Hanami::CLI.after "install", Commands::SolidJs::Install
      Hanami::CLI.after "install", Commands::Dev::Install
    end
  end
end
