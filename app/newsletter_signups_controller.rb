class NewsletterSignupsController < ApplicationController
  def create
    @newsletter_signup = NewsletterSignup.new(newsletter_params)
    if @newsletter_signup.save
      NotifyUserJob.perform_later(@newsletter_signup.id)
      flash[:notice] = "Subscribed!"
      redirect_to root_path
    else
      flash[:alert] = "Failed!"
      render "home/index"
    end
  end

  private

    def newsletter_params
      params.require(:newsletter_signup).permit(:email)
    end
end
