require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe 'GET /index' do
    it 'raises exception on not verified account' do
      allow(Account).to receive(:verified_by_id).and_raise(ActiveRecord::RecordNotFound)
      bypass_rescue
      expect {
        get :index, params: { account_id: 'some-id' }
      }.to raise_error(Exceptions::AccountNotVerifiedError)
    end

    it 'finds the verified account' do
      account = double('verified-account', id: 'some-id', transactions: ['list-of-histories'])
      url_segment = { account_id: 'some-id' }
      allow(AccountSerializer).to receive(:new).and_return({})
      expect(Account).to receive(:verified_by_id).with(url_segment[:account_id]).and_return(account)
      get :index, params: url_segment
    end
  end
end
