class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  belongs_to :requested_by_user, class_name: 'User', foreign_key: 'requested_by_user_id'
end
