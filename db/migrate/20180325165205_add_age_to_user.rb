class AddAgeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :string
  end
end
