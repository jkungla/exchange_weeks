class CreateCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :calculations do |t|
      t.string :base
      t.string :target
      t.float :amount
      t.integer :wait_time

      t.timestamps
    end
  end
end
