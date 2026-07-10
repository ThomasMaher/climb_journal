class Boulders < ActiveRecord::Migration[8.0]
  def change
    create_table :boulders do |t|
      t.integer :vgrade_range_min, null: false, index: true
      t.integer :vgrade_range_max, index: true, null: true
      t.integer :self_grade, index: true, null: true
      t.integer :incline, index: true, null: true

      t.integer :rating, index: true, null: true
      t.text :notes, limit: 400, null: true

      t.boolean :indoor, default: 0, index: true
      t.boolean :outdoor, default: 0, index: true
      t.boolean :kilter_board, default: 0, index: true

      t.string :nickname, limit: 50, index: true, null: true

      t.timestamps
    end
  end
end
