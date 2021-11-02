module RescueableAccountErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_account
    rescue_from Exceptions::LowAccountBalanceError, with: :handle_low_balance_error
  end

  def handle_not_found_account(exception)
    render json: { error: exception.message }, status: :forbidden
  end

  def handle_low_balance_error(exception)
    render json: { error: exception.message }, status: :forbidden
  end
end
