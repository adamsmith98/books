class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern

  before_action :set_user_lists

  private

  def set_user_lists
    @lists = Current.user.lists if authenticated?
  end
end
