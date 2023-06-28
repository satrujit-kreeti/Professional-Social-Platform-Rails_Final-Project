class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_photo
  has_one_attached :cv

  has_many :certificates, dependent: :destroy
  accepts_nested_attributes_for :certificates, allow_destroy: true

  has_many :friendships
  has_many :friends, through: :friendships


  validates :email, presence:true, uniqueness:true
  validates :username, presence:true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?


  def password_required?
    return false if password.present?
  end


  def compressed_profile_photo
    profile_photo.variant(resize: '48x48>').processed
  end

  def compressed_profile_photo_big
    profile_photo.variant(resize: '248x248>').processed
  end


end
