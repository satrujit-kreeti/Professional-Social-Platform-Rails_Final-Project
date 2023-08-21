# frozen_string_literal: true

class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_secure_password
  has_one_attached :profile_photo
  has_one_attached :cv

  has_many :certificates, dependent: :destroy
  accepts_nested_attributes_for :certificates, allow_destroy: true
  before_save :mark_blank_certificates_for_destruction

  has_many :friendships
  has_many :friends, through: :friendships

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email format' }
  validates :username, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: 'can only contain letters' }
  validates :password, presence: true, if: :password_required?

  validate :password_complexity, if: :password_required?

  def password_complexity
    return if password.match?(/\A(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}\z/)

    errors.add(:password,
               'must contain at least 1 capital letter, 1 number, 1 special character, and be at least 8 characters')
  end

  def password_required?
    password.present?
  end

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  before_save :mark_blank_comments_for_destruction
  before_save :mark_blank_posts_for_destruction

  has_many :likes, dependent: :destroy
  has_many :liking_posts, through: :likes, source: :post

  has_many :job_requirements, dependent: :destroy

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'recipient_id', dependent: :destroy

  has_many :job_profiles, dependent: :destroy
  accepts_nested_attributes_for :job_profiles, allow_destroy: true
  before_save :mark_blank_job_profiles_for_destruction

  def self.from_omniauth(auth)
    find_or_create_by(email: auth.info.email) do |new_user|
      new_user.username = "#{auth.info.first_name} #{auth.info.last_name}",
                          new_user.email = auth.info.email
    end
  end

  def mark_blank_certificates_for_destruction
    certificates.each do |certificate|
      certificate.mark_for_destruction if certificate.name.blank? && certificate.document.blank?
    end
  end

  def mark_blank_comments_for_destruction
    comments.each do |comment|
      comment.mark_for_destruction if comment.content.blank?
    end
  end

  def mark_blank_posts_for_destruction
    posts.each do |post|
      post.mark_for_destruction if post.content.blank?
    end
  end

  def mark_blank_job_profiles_for_destruction
    job_profiles.each do |job_profile|
      job_profile.mark_for_destruction if job_profile.title.blank?
    end
  end

  def compressed_profile_photo
    profile_photo.variant(resize: '48x48>').processed
  end

  def compressed_profile_photo_big
    profile_photo.variant(resize: '248x248>').processed
  end

  def admin?
    role == 'admin'
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'true' do
      indexes :username, type: :text
    end
  end

  def as_indexed_json(_options = {})
    {
      id:,
      username:
    }
  end

  def self.search_items(query)
    search_definition = {
      query: {
        bool: {
          must: query.present? ? [{ query_string: { query: "*#{query}*" } }] : []
        }
      }
    }

    __elasticsearch__.search(search_definition)
  end
end
