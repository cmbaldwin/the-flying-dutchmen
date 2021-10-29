require "friendly_id"
require "will_paginate"

require "fora/engine"
require "fora/forum_user"
require "fora/slack"
require "fora/version"
require "fora/will_paginate"

module Fora
  # Define who owns the subscription
  mattr_accessor :send_email_notifications
  mattr_accessor :send_slack_notifications
  @@send_email_notifications = true
  @@send_slack_notifications = true

  def self.setup
    yield self
  end
end
