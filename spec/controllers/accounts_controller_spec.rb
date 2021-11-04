require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
    let(:paramters){{ account: { creditor: { email: 'some-email' }, debitor: { phone: 'some-phone' }, amount: 'some-amount' } }}

  describe "#send_money" do
    before(:each) do
      request.headers['Content-Type'] = 'application/json'
    end

    context "with verified accounts" do
      let(:account){ double('verified-account') }

      it "expects to find accounts twice" do
        allow(account).to receive(:send_money)
        expect(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(account).twice
        post :send_money, params: paramters
      end

      it "expects to call send_money on credit account" do
        debit_account = double('verified-account')
        allow(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(debit_account, account)
        expect(debit_account).to receive(:send_money).with(anything, account)
        post :send_money, params: paramters
      end
    end

    context "with not verified accounts" do
      it 'raises exception on credit account' do
        allow(Account).to receive_message_chain(:verified_status, :find_by!).and_raise(ActiveRecord::RecordNotFound)
        expect {
          bypass_rescue
          post :send_money, params: paramters
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#receive_money" do
    context "with verified accounts" do
      let(:account){ double('verified-account') }

      it "expects to find accounts twice" do
        allow(account).to receive(:receive_money)
        expect(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(account).twice
        post :receive_money, params: paramters
      end

      it "expects to call send_money on credit account" do
        debit_account = double('verified-account')
        allow(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(account, debit_account)
        expect(account).to receive(:receive_money).with(anything, debit_account)
        post :receive_money, params: paramters
      end
    end

    context "with not verified accounts" do
      it 'raises exception on credit account' do
        allow(Account).to receive_message_chain(:verified_status, :find_by!).and_raise(ActiveRecord::RecordNotFound)
        expect {
          bypass_rescue
          post :receive_money, params: paramters
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
