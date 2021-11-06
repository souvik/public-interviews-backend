# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  balance      :decimal(10, 2)   default(0.0), not null
#  email        :string
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  status       :integer          default("pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_accounts_on_email         (email)
#  index_accounts_on_phone_number  (phone_number)
#  index_accounts_on_status        (status)
#
class Account < ApplicationRecord
  has_many :transactions, class_name: 'TransactionHistory'

  validates :first_name, :last_name, :email, :phone_number, presence: true

  enum status: {
    unverified: -1,
    pending: 0,
    verified: 1
  }, _suffix: true

  class << self
    def verified_and_fetch_by_email_or_phone(identifier)
      return verified_status.find_by!(email: identifier[:email]) if identifier.has_key?(:email)
      verified_status.find_by!(phone_number: identifier[:phone]) if identifier.has_key?(:phone)
    end

    def verified_by_id(id)
      verified_status.find(id)
    end
  end

  def send_money(amount, credit_account)
    raise Exceptions::LowAccountBalanceError.new("Unsufficient balance in debit account") if balance < amount
    self.transaction do
      withdraw!(amount)
      credit_account.deposit!(amount)
      log_this_transaction!(self, credit_account, amount)
    end
  end

  def receive_money(amount, debit_account)
    raise Exceptions::LowAccountBalanceError.new("Unsufficient balance in debit account") if debit_account.balance < amount
    self.transaction do
      debit_account.withdraw!(amount)
      deposit!(amount)
      log_this_transaction!(debit_account, self, amount)
    end
  end

  def withdraw!(withdrawal_amount)
    raise Exceptions::InvalidAccountStatusError.new("Account not in verified state") unless verified_status?
    update!(balance: balance - withdrawal_amount)
  end

  def deposit!(paid_amount)
    raise Exceptions::InvalidAccountStatusError.new("Account not in verified state") unless verified_status?
    update!(balance: balance + paid_amount)
  end

  private
  def log_this_transaction!(debit_account, credit_account, amount)
    TransactionHistory.create!([{
      account: debit_account, amount: amount, mode: TransactionHistory.modes[:debit]
    }, {
      account: credit_account, amount: amount, mode: TransactionHistory.modes[:credit]
    }])
  end
end
