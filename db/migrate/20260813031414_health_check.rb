class HealthCheck < ActiveRecord::Migration[8.0]
  def change
    create_table :health_checks do |t|
      t.integer :session_id, null: false, index: true
      t.integer :session_length, index: true

      t.integer :overall_assessment, index: true
      t.integer :finger_assessment, index: true
      t.integer :back_assessment, index: true
      t.integer :arms_assessment, index: true
      t.integer :lower_body_assessment, index: true

      t.text :notes, limit: 1000
    end
  end
end
