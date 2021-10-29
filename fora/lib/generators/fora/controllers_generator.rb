require "rails/generators"

module Fora
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../..", __FILE__)

      def copy_controllers
        directory "app/controllers/fora", "app/controllers/fora"
      end
    end
  end
end
