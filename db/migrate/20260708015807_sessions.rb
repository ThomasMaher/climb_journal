class Sessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.date :date, index: true
      t.string :gym_name, limit: 50, index: true
      t.text :notes, limit: 255
      t.timestamps
    end
  end
end
