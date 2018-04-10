class RemoveUrlFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :profile_images, :url
  end
end
