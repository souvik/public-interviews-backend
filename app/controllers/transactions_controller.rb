class TransactionsController < ApplicationController
  include RescueableTransactionErrors

  def index
    account = Account.verified_by_id(params[:account_id])
    render json: AccountSerializer.new(account, { params: { show_history: true } }), status: :ok
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::AccountNotVerifiedError
  end
end
