class ApplicationController < ActionController::Base
  protect_from_forgery
  @@current_user = User.find_or_create_by_full_name("Demo User")

  def self.current_user=(user)
    @@current_user = user
  end

  def current_user
    @@current_user
  end
  helper_method :current_user

  def destroy_user_session_path
    ''
  end
  helper_method :destroy_user_session_path

  def authenticate_user!
    true
  end

  def anybody_signed_in?
    true
  end
end
