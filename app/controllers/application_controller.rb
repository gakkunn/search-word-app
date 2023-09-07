class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production? 
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller? 

  def after_sign_in_path_for(resource)
    blocks_path
  end

  private

    def production?
      Rails.env.production?
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["BASIC_AUTH_USERNAME"] && password == ENV["BASIC_AUTH_PASSWORD"]
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :password])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :password])
    end
end