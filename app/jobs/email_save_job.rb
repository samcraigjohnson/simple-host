class EmailSaveJob < ApplicationJob
  queue_as :default

  def perform(email)
    NewsletterSignup.create!(email:)
  end
end
