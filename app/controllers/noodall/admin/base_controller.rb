module Noodall
  module Admin
    class BaseController < ApplicationController
      layout 'noodall_admin'
      before_filter :authenticate_user!
    end
  end
end
