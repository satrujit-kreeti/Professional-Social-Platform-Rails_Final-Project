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

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true, if: :password_required?

  has_many :posts
  has_many :comments
  before_save :mark_blank_comments_for_destruction
  before_save :mark_blank_posts_for_destruction

  has_many :likes
  has_many :liking_posts, through: :likes, source: :post

  has_many :job_requirements

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'recipient_id', dependent: :destroy

  has_many :job_profiles, dependent: :destroy
  accepts_nested_attributes_for :job_profiles, allow_destroy: true
  before_save :mark_blank_job_profiles_for_destruction

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

  def password_required?
    return false if password.present?
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
