# == Schema Information
#
# Table name: transaction_histories
#
#  id         :bigint           not null, primary key
#  amount     :decimal(10, 2)   default(0.0), not null
#  mode       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#
# Indexes
#
#  index_transaction_histories_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe TransactionHistory, type: :model do
end
