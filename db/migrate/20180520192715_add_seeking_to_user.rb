class AddSeekingToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :seeking, :integer
  end
end
