class AddEmailAndPasswordIndexToUsers < ActiveRecord::Migration[5.1]
  def change
      add_index :users, :email, unique: true
      add_index :users, :phone_number, unique: true
  end
end
