class AccountsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_account
  rescue_from Exceptions::LowAccountBalanceError, with: :handle_low_balance_error

  def send_money
    @debit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:debitor])
    credit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:creditor])
    @debit_account.send_money(account_params[:amount], credit_account)
    render json: @debit_account, status: :ok
  end

  private
  def account_params
    params.require(:account).permit(:amount, creditor: [:email, :phone], debitor: [:email, :phone])
  end

  def handle_not_found_account(exception)
    render json: { error: exception.message }, status: :forbidden
  end

  def handle_low_balance_error(exception)
    render json: { error: exception.message }, status: :forbidden
  end
end
