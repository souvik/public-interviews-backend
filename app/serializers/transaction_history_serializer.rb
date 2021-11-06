class TransactionHistorySerializer
  include JSONAPI::Serializer

  attributes :amount, :mode

  belongs_to :account
end
