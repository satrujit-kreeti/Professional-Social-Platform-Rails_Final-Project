class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  has_many :likes
  has_many :liking_users, through: :likes, source: :user

  def liked_by?(user)
    liking_users.include?(user)
  end
end
