class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(signup_id)
    ns = NewsletterSignup.find(signup_id)
    puts "Notifying User that they signed up #{ns.id}"
  end
end
