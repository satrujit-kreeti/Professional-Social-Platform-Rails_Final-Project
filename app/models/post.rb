# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  enum status: { pending: 'pending', approved: 'approved', rejected: 'rejected' }

  def liked_by?(user)
    liking_users.include?(user)
  end
end
