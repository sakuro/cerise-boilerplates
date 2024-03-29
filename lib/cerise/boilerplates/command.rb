# frozen_string_literal: true

require "erb"
require "pathname"
require "shellwords"

require "dry/files"
require "dry/inflector"

require "hanami/cli/bundler"
require "hanami/cli/command"
require "hanami/cli/generators/context"
require "hanami/cli/system_call"
require "hanami/utils/kernel"

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

      private def execute_command(command, args)
        system_call.call(command, args).tap do |result|
          unless result.successful?
            puts "Error from #{command}"
            puts(result.err.lines.map {|line| line.prepend("\t") })
          end
        end
      end

      private def npm_install(*packages, development: false)
        puts "Installing npm packages: %p" % [packages]
        if development
          args = ["install", *packages, "--save-dev"]
        else
          args = ["install", *packages]
        end
        execute_command("npm", args)
      end

      private def add_gems(*gems, group: [], skip_install: false)
        puts "Adding gems: %p" % [gems]
        args = ["add", *gems]
        args += %w(--group) + Hanami::Utils::Kernel.Array(group) unless group.empty?
        args += %w(--skip-install) if skip_install
        bundler.bundle(Shellwords.join(args))
      end

      private def add_git_ignore(*entries)
        puts "Adding .gitignore entries: %p" % [entries]
        entries.each do |entry|
          fs.append(".gitignore", entry)
        end
      end

      private def create_spec_support(feature)
        puts "Creating RSpec support feature: %p" % feature
        fs.write("spec/support/#{feature}.rb", template("spec/support/#{feature}.rb"))
        fs.append("spec/spec_helper.rb", %(require_relative "support/#{feature}"))
      end

      private def create_rake_task(task)
        puts "Creating Rake tasks: %p" % task
        fs.write("lib/tasks/#{task}.rb", template("lib/tasks/#{task}.rb"))
      end

      private def template(path)
        puts "Applying template: %p" % path
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
