class AddCantorIdentifierIndexToMatches < ActiveRecord::Migration[5.1]
  def change
    add_index :matches, :cantor_identifier, unique: true
  end
end
