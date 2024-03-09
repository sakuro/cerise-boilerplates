# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Session
        class Install < Cerise::Boilerplates::Command
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
            fs.inject_line_at_class_bottom("config/app.rb", "App", <<~RUBY)
              config.actions.sessions = :cookie, {
                key: "#{context.underscored_app_name}.session",
                secret: settings.session_secret,
                expire_after: 60*60*24*365
              }
            RUBY
          end
        end
      end
    end
  end
end
