module Fora
  class Engine < ::Rails::Engine
    engine_name "fora"

    # Grab the Rails default url options and use them for sending notifications
    config.after_initialize do
      Fora::Engine.routes.default_url_options = ActionMailer::Base.default_url_options
    end
  end
end
