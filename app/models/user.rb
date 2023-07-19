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

  has_many :posts
  has_many :comments

  has_many :likes
  has_many :liking_posts, through: :likes, source: :post

  has_many :job_requirements

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'recipient_id'


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


  # Elastic Search
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'true' do
      indexes :username, type: :text
    end
  end

  def as_indexed_json(_options = {})
    {
      id: id,
      username: username
    }
  end

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  def self.search_items(query)
    search_definition = {
      query: {
        bool: {
          must: []
        }
      }
    }

    if query.present?
      search_definition[:query][:bool][:must] << {
        query_string: {
          query: "*#{query}*"
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end
end
