# frozen_string_literal: true

require "erb"
require "pathname"

require "dry/files"
require "dry/inflector"

require "hanami/cli/bundler"
require "hanami/cli/command"
require "hanami/cli/generators/context"
require "hanami/cli/system_call"

module Cerise
  module Boilerplates
    class Command < Hanami::CLI::Command
      ENVIRONMENTS = %w[development test].freeze
      private_constant :ENVIRONMENTS

      def initialize(
        app: File.basename(Dir.pwd),
        inflector: Dry::Inflector.new,

        fs: Dry::Files.new,
        bundler: Hanami::CLI::Bundler.new(fs:),
        context: Hanami::CLI::Generators::Context.new(inflector, app),
        system_call: Hanami::CLI::SystemCall.new,
        **opts
      )

        super(fs:, inflector:, **opts)
        @bundler = bundler
        @context = context
        @system_call = system_call
      end

      private attr_reader :bundler, :context, :system_call

      private def npm_install(*packages, development: false)
        if development
          args = ["install", *packages, "--save-dev"]
          puts "Installing npm packages for development: %p" % [packages]
        else
          puts "Installing npm packages: %p" % [packages]
          args = ["install", *packages]
        end
        system_call.call("npm", args).tap do |result|
          unless result.successful?
            puts "NPM ERROR:"
            puts(result.err.lines.map {|line| line.prepend("    ") })
          end
        end
      end

      private def create_spec_support(feature)
        fs.write("spec/support/#{feature}.rb", template("spec/support/#{feature}.rb"))
        fs.append("spec/spec_helper.rb", %(require_relative "support/#{feature}"))
      end

      private def create_rake_task(task)
        fs.write("lib/tasks/#{task}.rake", template("lib/tasks/#{task}.rake"))
        fs.append("Rakefile", %(load "./lib/tasks/#{task}.rake"))
      end

      private def template(path)
        base_dir = inflector.underscore(self.class.name).delete_prefix("cerise/boilerplates/commands/")
        content = File.read(template_root_dir / base_dir / path)
        ERB.new(content, trim_mode: "-").result(context.ctx)
      end

      private def template_root_dir
        @template_root_dir ||= Pathname(File.join(__dir__, "../../../templates")).cleanpath
      end
    end
  end
end
