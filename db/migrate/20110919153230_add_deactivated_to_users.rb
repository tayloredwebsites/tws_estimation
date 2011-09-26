class AddDeactivatedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :deactivated, :string
  end

  def self.down
    remove_column :users, :deactivated
  end
end
