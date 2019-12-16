module ShopifyCli
  module ScriptModule
    module Infrastructure
      class TypeScriptDependencyManager
        def initialize(script_name, language)
          @language = language
          @script_name = script_name
        end

        def installed?
          # Assuming if node_modules folder exist at root of script folder, all deps are installed
          Dir.exist?("node_modules")
        end

        def install
          unless system('npm --version > /dev/null')
            # There is no way to automatically install NPM as far as I know
            raise(ShopifyCli::Abort, "{{x}} Please install NPM")
          end

          write_package_json

          unless system('npm install --no-audit --no-optional')
            raise(ShopifyCli::Abort, "{{x}} Installing dependencies failed")
          end
        end

        private

        def write_package_json
          package_json = <<~HERE
          {
            "name": "#{@script_name}",
            "version": "1.0.0",
            "devDependencies": {
              "@as-pect/assembly": "^2.6.0",
              "@as-pect/cli": "^2.6.0",
              "@as-pect/core": "^2.6.0",
              "assemblyscript": "0.8.0",
              "ts-node": "^8.5.4",
              "typescript": "^3.7.3"
            },
            "scripts": {
              "test": "asp --config test/as-pect.config.js"
            }
          }
          HERE

          File.write("package.json", package_json)
        end
      end
    end
  end
end