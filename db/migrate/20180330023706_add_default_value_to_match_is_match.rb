class AddDefaultValueToMatchIsMatch < ActiveRecord::Migration[5.1]
  def change
    change_column :matches, :is_match, :boolean, :default => false
  end
end
