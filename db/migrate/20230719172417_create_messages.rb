class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.integer :sender_id
      t.integer :recipient_id
      t.text :body
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
