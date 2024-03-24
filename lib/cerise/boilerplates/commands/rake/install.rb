# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module Rake
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            create_rake_task("environment")
            append_glob_require
          end

          private def append_glob_require
            fs.append("Rakefile", <<~RUBY)
            FileList["lib/tasks/*.rb"].each {|t| require_relative t }
            RUBY
          end
        end
      end
    end
  end
end
