class RemoveUserAgeGenderBio < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :age, :string
    remove_column :users, :bio, :string
    remove_column :users, :gender, :integer
  end
end
