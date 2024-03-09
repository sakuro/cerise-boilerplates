# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Rake
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            fs.append("Rakefile", 'Dir["lib/tasks/*.rake"].each(&method(:require))')
            create_rake_task("environment")
          end
        end
      end
    end
  end
end
