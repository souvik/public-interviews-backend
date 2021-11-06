require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  describe "GET /index" do
    it 'returns forbidden on pending account' do
      account = create(:pending_account)
      get account_transactions_path(account_id: account)
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns forbidden on unverified account' do
      account = create(:unverified_account)
      get account_transactions_path(account_id: account)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
