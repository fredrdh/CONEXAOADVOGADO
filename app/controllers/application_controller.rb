class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization
  after_action :verify_authorized, except: %i[sobre adv]
  after_action :verify_policy_scoped, except: %i[sobre adv]
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    array_permit = %i[name CPF phone email password password_confirmation current_passwor]
    devise_parameter_sanitizer.permit(:sign_up, keys: array_permit)
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login email password remember_me])
    devise_parameter_sanitizer.permit(:account_update, keys: array_permit)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def skip_pundit_authorization
    skip_authorization
    skip_policy_scope
  end
end
