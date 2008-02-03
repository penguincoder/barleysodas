class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.column :code, :string, :limit => 32
      t.column :people_id, :integer
      t.column :sent, :boolean, :default => false
    end
    add_index :invitations, :people_id
  end

  def self.down
    drop_table :invitations
  end
end
