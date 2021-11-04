class AccountsController < ApplicationController
  include RescueableAccountErrors

  def send_money
    @debit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:debitor])
    credit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:creditor])
    if @debit_account.send_money(account_params[:amount], credit_account)
      render json: @debit_account, status: :ok
    end
  end

  def receive_money
    @credit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:creditor])
    debit_account = Account.verified_and_fetch_by_email_or_phone(account_params[:debitor])
    if @credit_account.receive_money(account_params[:amount], debit_account)
      render json: @credit_account, status: :ok
    end
  end

  private
  def account_params
    params.require(:account).permit(:amount, creditor: [:email, :phone], debitor: [:email, :phone])
  end
end
