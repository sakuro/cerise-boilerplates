# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Finalize
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            create_binstubs
            apply_autocorrect
            generate_rubocop_todo_yml
          end

          private def create_binstubs
            bundler.bundle("binstubs --all")
          end

          private def generate_rubocop_todo_yml
            fs.touch(".rubocop_todo.yml") unless fs.exist?(".rubocop_todo.yml")
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
