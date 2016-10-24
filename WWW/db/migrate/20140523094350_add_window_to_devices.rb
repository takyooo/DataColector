class AddWindowToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :window, :string
  end
end
