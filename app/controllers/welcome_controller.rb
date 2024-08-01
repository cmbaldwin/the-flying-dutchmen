class WelcomeController < ApplicationController
  def privacy
    render 'privacy'
  end

  def cookies
    render 'cookies'
  end

  def terms
    render 'terms'
  end
end
