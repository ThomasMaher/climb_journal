class CreateBoulderPhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :boulder_photos do |t|
      t.references :boulder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :caption

      t.timestamps
    end
  end
end
