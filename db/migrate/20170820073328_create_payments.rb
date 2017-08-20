class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :email
      t.string :token
      t.integer :reservation_id
      t.integer :amount

      t.timestamps
    end
  end
end
