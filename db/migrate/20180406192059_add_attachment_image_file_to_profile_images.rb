class AddAttachmentImageFileToProfileImages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :profile_images do |t|
      t.attachment :image_file
    end
  end

  def self.down
    remove_attachment :profile_images, :image_file
  end
end
