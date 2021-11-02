require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe "#send_money" do
    before(:each) do
      request.headers['Content-Type'] = 'application/json'
    end

    context "with verified account" do
      let(:account){ double('verified-account') }

      it "expects to find accounts twice" do
        allow(account).to receive(:send_money)
        expect(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(account).twice
        post :send_money, params: { account: { creditor: { email: 'some-email' }, debitor: { phone: 'some-phone' }, amount: 'some-amount' } }
      end

      it "expects to call send_money on credit account" do
        debit_account = double('verified-account')
        allow(Account).to receive(:verified_and_fetch_by_email_or_phone).and_return(account, debit_account)
        expect(account).to receive(:send_money).with(anything, debit_account)
        post :send_money, params: { account: { creditor: { email: 'some-email' }, debitor: { phone: 'some-phone' }, amount: 'some-amount' } }
      end
    end
  end
end
