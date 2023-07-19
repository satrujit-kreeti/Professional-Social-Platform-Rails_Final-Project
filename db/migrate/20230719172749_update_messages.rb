class UpdateMessages < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :conversations, :users, column: :sender_id
    add_foreign_key :conversations, :users, column: :recipient_id
  end
end
