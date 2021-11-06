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
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { build(:account) }

  it 'has a valid factory' do
    expect(account).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe '#verified_and_fetch_by_email_or_phone' do
    it 'raises exception on pending account' do
      pending_account = create(:pending_account)
      expect{
        Account.verified_and_fetch_by_email_or_phone({email: pending_account.email})
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises exception on unverified account' do
      unverified_account = create(:unverified_account)
      expect{
        Account.verified_and_fetch_by_email_or_phone({phone: unverified_account.phone_number})
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should fetch verified account' do
      verified_account = create(:verified_account)
      expect(Account.verified_and_fetch_by_email_or_phone(email: verified_account.email)).to eq(verified_account)
    end
  end

  describe '#send_money' do
    let(:debit_account){ create(:verified_account, balance: 234.58) }
    let(:credit_account){ create(:verified_account) }

    it 'raises exception if less debit account balance' do
      expect{
        debit_account.send_money(500, credit_account)
      }.to raise_error(Exceptions::LowAccountBalanceError, "Unsufficient balance in debit account")
    end

    it 'deducts amount from the debit account balance' do
      transfer_amount = 50
      initial_balance = debit_account.balance
      expect{
        debit_account.send_money(transfer_amount, credit_account)
      }.to change(debit_account, :balance).from(initial_balance).to(initial_balance - transfer_amount)
    end

    it 'deposits amount to the credit account balance' do
      transfer_amount = 50
      initial_balance = credit_account.balance
      expect{
        debit_account.send_money(transfer_amount, credit_account)
      }.to change(credit_account, :balance).from(initial_balance).to(initial_balance + transfer_amount)
    end

    it 'logs the transaction as debit for debit account' do
      expect{
        debit_account.send_money(50, credit_account)
      }.to change{ debit_account.transactions.count }.by(1)
    end

    it 'logs the transaction as credit for credit account' do
      expect{
        debit_account.send_money(50, credit_account)
      }.to change{ credit_account.transactions.count }.by(1)
    end
  end

  describe '#receive_money' do
    let(:debit_account){ create(:verified_account, balance: 234.58) }
    let(:credit_account){ create(:verified_account) }

    it 'raises exception if less debit account balance' do
      expect{
        credit_account.receive_money(500, debit_account)
      }.to raise_error(Exceptions::LowAccountBalanceError, "Unsufficient balance in debit account")
    end

    it 'deducts amount from the debit account balance' do
      transfer_amount = 50
      initial_balance = debit_account.balance
      expect{
        credit_account.receive_money(transfer_amount, debit_account)
      }.to change(debit_account, :balance).from(initial_balance).to(initial_balance - transfer_amount)
    end

    it 'deposits amount to the credit account balance' do
      transfer_amount = 50
      initial_balance = credit_account.balance
      expect{
        credit_account.receive_money(transfer_amount, debit_account)
      }.to change(credit_account, :balance).from(initial_balance).to(initial_balance + transfer_amount)
    end

    it 'logs the transaction as debit for debit account' do
      expect{
        credit_account.receive_money(50, debit_account)
      }.to change{ debit_account.transactions.count }.by(1)
    end

    it 'logs the transaction as credit for credit account' do
      expect{
        credit_account.receive_money(50, debit_account)
      }.to change{ credit_account.transactions.count }.by(1)
    end
  end
end
