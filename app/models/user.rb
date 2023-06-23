class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_photo

  validates :email, presence:true, uniqueness:true
  validates :username, presence:true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?


  def password_required?
    return false if password.present?
  end



end
