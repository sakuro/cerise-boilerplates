# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Rubocop
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            install_gems
            create_configs
            generate_rubocop_todo_yml
            apply_autocorrect
          end

          private def install_gems
            bundler.bundle("add rubocop rubocop-performance rubocop-rake rubocop-rspec --group development")
          end

          private def create_configs
            execute_command("git", ["submodule", "add", "https://github.com/sakuro/rubocop-config", ".rubocop"])
            execute_command("git", ["submodule", "update", "--init"])
            fs.write(".rubocop.yml", template("dot.rubocop.yml"))
          end

          private def generate_rubocop_todo_yml
            bundler.exec("rubocop --auto-gen-config")
          end

          private def apply_autocorrect
            bundler.exec("rubocop --autocorrect")
          end
        end
      end
    end
  end
end
