# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Rake
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            create_rake_task("environment")
          end
        end
      end
    end
  end
end
