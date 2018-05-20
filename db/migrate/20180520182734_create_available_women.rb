class CreateAvailableWomen < ActiveRecord::Migration[5.1]
  def change
    create_table :available_women do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
