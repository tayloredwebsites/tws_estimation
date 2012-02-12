class BooleanDeactivatedToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :deactivated
    add_column :users, :deactivated, :boolean
  end

  def self.down
    remove_column :users, :deactivated
    add_column :users, :deactivated, :string
  end
end
