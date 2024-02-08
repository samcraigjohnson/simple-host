class HomeController < ApplicationController
  def index
    @newsletter_signup = NewsletterSignup.new
  end
end
