class CreateProfileImages < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_images do |t|
      t.string :url

      t.timestamps
    end
  end
end
