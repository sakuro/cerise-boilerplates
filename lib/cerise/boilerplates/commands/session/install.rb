# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Session
        class Install < Cerise::Boilerplates::Command
          SESSION_SETTING = <<~RUBY
            config.actions.sessions = :cookie, {
              expire_after: 60 * 60 * 24 * 365, # 1 year
              key: "%<app_name>s.session",
              same_site: "Lax",
              secret: settings.session_secret
            }
          RUBY
          private_constant :SESSION_SETTING

          def call(*, **)
            create_session_setting
            create_session_config
          end

          private def create_session_setting
            fs.inject_line_at_class_bottom("config/settings.rb", "Settings", "setting :session_secret, constructor: Types::String")
            ENVIRONMENTS.each do |environment|
              fs.append(".env.#{environment}.local", "SESSION_SECRET=__#{context.underscored_app_name}_session_#{environment}__")
            end
          end

          private def create_session_config
            app_name = context.underscored_app_name
            fs.inject_line_at_class_bottom("config/app.rb", "App", SESSION_SETTING % {app_name:})
          end
        end
      end
    end
  end
end
