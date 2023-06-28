class AddRequestedByUserIdToFriendships < ActiveRecord::Migration[6.1]
  def change
    add_column :friendships, :requested_by_user_id, :integer
    add_index :friendships, :requested_by_user_id
  end
end
