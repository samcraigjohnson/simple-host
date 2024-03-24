class HomeController < ApplicationController
  def index
    @newsletter_signup = NewsletterSignup.new
  end

  def pitr
    @important_infos = ImportantInfo.all.limit(1000).order(created_at: :desc)
  end

  def important_delete
    ImportantInfo.delete_all
    redirect_to pitr_path
  end

  def create_info
    10.times { ImportantInfo.create! }
    redirect_to pitr_path
  end
end
