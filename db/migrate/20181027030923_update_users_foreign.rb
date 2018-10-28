class UpdateUsersForeign < ActiveRecord::Migration[5.1]
  def change
    # remove the old foreign_key
    remove_foreign_key :profile_images, :users

    # add the new foreign_key
    add_foreign_key :profile_images, :users, on_delete: :cascade
  end
end
