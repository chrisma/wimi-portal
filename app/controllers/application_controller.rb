class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_valid_email

  def ensure_valid_email
    if current_user.nil?
      if request.env['PATH_INFO'] != '/users/sign_in'
        flash[:error] = 'Please login first'
        redirect_to '/users/sign_in'
      end
    else
      if !current_user.valid? && ![destroy_user_session_path, edit_user_path(current_user), user_path(current_user)].include?(request.env['PATH_INFO'])
        flash[:error] = 'Please set a valid email address first'
        redirect_to edit_user_path(current_user)
      end
    end
  end
end
