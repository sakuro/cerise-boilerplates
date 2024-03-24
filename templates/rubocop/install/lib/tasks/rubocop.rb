# frozen_string_literal: true

require "rubocop/rake_task"

module RuboCop
  class RakeTask
    module AddRegenerateToDo
      # Enhances RakeTask to define regenerate_todo task
      def setup_subtasks(name, *args, &task_block)
        super

        namespace(name) do
          desc "Regenerate RuboCop's TooDo"
          task(:regenerate_todo, *args) do |_, task_args|
            RakeFileUtils.verbose(verbose) do
              yield(*[self, task_args].slice(0, task_block.arity)) if task_block
              perform("--regenerate-todo")
            end
          end
        end
      end
    end

    private_constant :AddRegenerateToDo
    prepend AddRegenerateToDo

    new(:rubocop) do |task|
      task.options = %w[--display-cop-names --display-style-guide --extra-details]
      task.formatters << "github" if ENV["GITHUB_ACTIONS"] == "true"
    end
  end
end

Rake::Task[:default].prerequisites << :rubocop
