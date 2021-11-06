module RescueableTransactionErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Exceptions::AccountNotVerifiedError, with: :handle_account_not_verified_error
  end

  def handle_account_not_verified_error(exception)
    render json: { error: exception.message }, status: :forbidden
  end
end
