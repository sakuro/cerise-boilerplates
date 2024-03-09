# frozen_string_literal: true

require "uri/generic"

module Cerise
  module Boilerplates
    module Commands
      module Persistence
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            bundler.bundle("add rom rom-sql pg")
            bundler.bundle("add database_clearner-sequel --group test")
            create_database_url_setting
            create_persistence_provider
            create_spec_support("database_cleaner")
            create_rake_task("db")
            create_databases
          end

          private def create_database_url_setting
            fs.inject_line_at_class_bottom("config/settings.rb", /Settings/, "setting :database_url, constructor: Types::String")
            ENVIRONMENTS.each do |environment|
              fs.append(".env.#{environment}.local", "DATABASE_URL=#{database_url(environment)}")
            end
          end

          private def create_persistence_provider
            fs.write("config/providers/persistence.rb", template("config/providers/persistence.rb"))
          end

          private def create_databases
            ENVIRONMENTS.each do |environment|
              puts "Creating #{environment} database"
              system_call.call("createdb #{database_name(environment)}")
            end
          end

          private def database_url(environment)
            URI::Generic.build(
              scheme: "postgres",
              userinfo: %w[posetgres posegres].join(":"),
              host: "localhost",
              port: 5432,
              path: "/#{database_name(environment)}"
            )
          end

          private def database_name(environment)
            "#{context.underscored_app_name}_#{environment}"
          end
        end
      end
    end
  end
end
