class SessionClimbs < ActiveRecord::Migration[8.0]
  def change
    create_table :session_climbs do |t|
      t.integer :session_id, null: false
      t.integer :boulder_id, null: false, index: true
      t.integer :user_id, index: true, null: false

      t.integer :attempts, index: true
      t.integer :percent_finished, null: false, index: true

      t.text :notes, limit: 400

      t.timestamps

      t.index [ :session_id, :boulder_id ], unique: true
    end
  end
end
