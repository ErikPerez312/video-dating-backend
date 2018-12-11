class AddAgeAndBioToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :string
    add_column :users, :bio, :string
  end
end
