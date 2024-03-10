# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Dev
        class Install < Cerise::Boilerplates::Command
          GIT_IGNORE_ENTRIES = %w[
            .env.local
            .env.*.local
            vendor/bundle/
          ].freeze
          private_constant :GIT_IGNORE_ENTRIES

          def call(*, **)
            install_support_gems
            create_spec_support("faker")
            remove_unwanted_foreman_installation
            create_binstubs
            append_git_ignore_entries
          end

          private def install_support_gems
            bundler.bundle("add ruby-lsp foreman --group development --skip-install")
            bundler.bundle("add faker --group test --skip-install")
            bundler.bundle("add debug repl_type_completor --group development,test")
          end

          private def remove_unwanted_foreman_installation
            system_call.call('(rm -f bin/dev && sed -e "/^if/,/^fi/d" > bin/dev && chmod +x bin/dev) < bin/dev')
          end

          private def create_binstubs
            bundler.bundle("binstubs --all")
          end

          private def append_git_ignore_entries
            GIT_IGNORE_ENTRIES.each do |entry|
              fs.append(".gitignore", entry)
            end
          end
        end
      end
    end
  end
end
