class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :date
      t.integer :sensor
      t.decimal :value
      t.integer :token_id

      t.timestamps 

    end
  end
end
