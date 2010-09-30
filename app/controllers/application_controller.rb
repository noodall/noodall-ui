require 'noodall-core'

class ApplicationController < ActionController::Base
  include Canable::Enforcers
  protect_from_forgery
  @@current_user = User.find_or_create_by_full_name("Demo User")

  def self.current_user=(user)
    @@current_user = user
  end
  
  def current_user
    @@current_user
  end
  helper_method :current_user

  def session_path
    ''
  end
  helper_method :session_path
end
