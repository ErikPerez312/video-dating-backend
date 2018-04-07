class AddUserToProfileImages < ActiveRecord::Migration[5.1]
  def change
    add_reference :profile_images, :user, foreign_key: true
  end
end
