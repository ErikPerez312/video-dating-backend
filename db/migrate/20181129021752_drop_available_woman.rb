class DropAvailableWoman < ActiveRecord::Migration[5.1]
  def change
    drop_table :available_women
    drop_table :available_men
  end
end
