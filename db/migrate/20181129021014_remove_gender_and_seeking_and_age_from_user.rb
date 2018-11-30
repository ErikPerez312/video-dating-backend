class RemoveGenderAndSeekingAndAgeFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :age, :string
    remove_column :users, :seeking, :integer
    remove_column :users, :gender, :integer
  end
end
