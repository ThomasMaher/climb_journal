class AddCreatedByIdToBoulders < ActiveRecord::Migration[8.0]
  def change
    add_column :boulders, :created_by_id, :integer
    add_index :boulders, :created_by_id
  end
end
