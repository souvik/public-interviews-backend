require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  describe "POST /send_money" do
    let(:receiver){ create(:account) }
    let(:verified_account){ create(:verified_account) }

    it "returns forbidden on pending sender account" do
      sender = create(:pending_account)
      trans_params = {
        debitor: { email: sender.email },
        creditor: { email: receiver.email },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:forbidden)
    end

    it "returns forbidden on unverified sender account" do
      sender = create(:unverified_account)
      trans_params = {
        debitor: { email: sender.email },
        creditor: { email: receiver.email },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns forbidden on pending receiver account' do
      pending_receiver = create(:pending_account)
      trans_params = {
        debitor: { email: verified_account.email },
        creditor: { phone: pending_receiver.phone_number },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns forbidden on unverified receiver account' do
      unverified_receiver = create(:unverified_account)
      trans_params = {
        debitor: { email: verified_account.email },
        creditor: { phone: unverified_receiver.phone_number },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:forbidden)
    end

    it "returns OK on verified accounts" do
      sender = create(:verified_account, balance: 8700.89)
      receiver = create(:verified_account)
      trans_params = {
        debitor: { email: sender.email },
        creditor: { email: receiver.email },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:ok)
    end

    it "return forbidden on sender's unsufficient balance" do
      sender = create(:verified_account, balance: 50)
      receiver = create(:verified_account)
      trans_params = {
        debitor: { email: sender.email },
        creditor: { email: receiver.email },
        amount: 100.89
      }
      post send_money_accounts_path, params: { account: trans_params }.to_json, headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
