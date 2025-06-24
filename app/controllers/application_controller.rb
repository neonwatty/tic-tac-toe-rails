class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_session

  helper_method :current_user

  def current_user
    Current.user
  end

  private

  def set_current_session
    if cookies.signed[:session_id]
      Current.session ||= Session.find_by(id: cookies.signed[:session_id])
    end
  end
end
