# frozen_string_literal: true

module Cerise
  module Boilerplates
    module Commands
      module SolidJs
        class Install < Cerise::Boilerplates::Command
          def call(*, **)
            install_solid_js
            install_esbuild_plugin_solid
            replace_config_assets_js
            replace_app_js_with_app_tsx
            create_tsconfig_json
          end

          private def install_solid_js
            npm_install("solid-js")
          end

          private def install_esbuild_plugin_solid
            npm_install("esbuild-plugin-solid", development: true)
          end

          private def replace_config_assets_js
            fs.delete("config/assets.js")
            fs.write("config/assets.js", template("config/assets.js"))
          end

          private def replace_app_js_with_app_tsx
            fs.delete("app/assets/js/app.js")
            fs.write("app/assets/js/app.tsx", template("app/assets/js/app.tsx"))
          end

          private def create_tsconfig_json
            fs.write("tsconfig.json", template("tsconfig.json"))
          end
        end
      end
    end
  end
end
