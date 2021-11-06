class AccountSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower
  attributes :first_name, :last_name, :email, :phone_number, :balance, :status

  attribute :transactions, serializer: TransactionHistorySerializer, if: Proc.new{ |record, params| params && params[:show_history] == true }
end
