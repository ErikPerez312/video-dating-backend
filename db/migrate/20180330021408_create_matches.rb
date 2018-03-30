class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :cantor_identifier
      t.boolean :is_match

      t.timestamps
    end
  end
end
