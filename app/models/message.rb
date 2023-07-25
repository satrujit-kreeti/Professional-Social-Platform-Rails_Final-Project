class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates_presence_of :body

  scope :unread_from_sender, ->(user) { where(read: false).where.not(sender_id: user.id) }
end
