class CreateTransactionHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_histories do |t|
      t.references :account, index: true
      t.decimal :amount, precision: 10, scale: 2, null: false,  default: 0
      t.integer :mode, null: false
      t.timestamps
    end
  end
end
