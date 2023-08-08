# frozen_string_literal: true

class Certificate < ApplicationRecord
  belongs_to :user
  has_one_attached :document
  validates :name, presence: true, if: -> { document.attached? }

  validate :validate_presence_of_name_or_document, on: :create

  private

  def validate_presence_of_name_or_document
    return if name.blank? && document.blank? && user_id.blank?

    errors.add(:base, 'Name or Document must be present')
  end
end
