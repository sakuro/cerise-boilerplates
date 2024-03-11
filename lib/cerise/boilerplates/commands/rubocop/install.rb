# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Rubocop
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            add_gems("rubocop", "rubocop-performance", "rubocop-rake", "rubocop-rspec", group: :development)
            create_configs
          end

          private def create_configs
            execute_command("git", ["submodule", "add", "https://github.com/sakuro/rubocop-config", ".rubocop"])
            execute_command("git", ["submodule", "update", "--init"])
            fs.write(".rubocop.yml", template("dot.rubocop.yml"))
          end
        end
      end
    end
  end
end
