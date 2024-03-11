# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Dev
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            add_gems("ruby-lsp", "foreman", group: :development, skip_install: true)
            add_gems("faker", group: :test, skip_install: true)
            add_gems("debug", "repl_type_completor", group: %i[development test])

            create_spec_support("faker")

            add_git_ignore(".env.local", ".env.*.local", "vendor/bundle/")

            remove_unwanted_foreman_installation
          end

          private def remove_unwanted_foreman_installation
            system_call.call('(rm -f bin/dev && sed -e "/^if/,/^fi/d" > bin/dev && chmod +x bin/dev) < bin/dev')
          end
        end
      end
    end
  end
end
