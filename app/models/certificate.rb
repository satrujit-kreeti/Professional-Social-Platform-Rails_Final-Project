# frozen_string_literal: true

class Certificate < ApplicationRecord
  belongs_to :user
  has_one_attached :document
  validates :name, presence: true, if: -> { document.attached? }

  validate :name_and_document_presence

  private

  def name_and_document_presence
    if name.blank? && document.attached?
      errors.add(:base, 'Both name and document must be present if one of them is present')
    elsif name.present? && !document.attached?
      errors.add(:base, 'Both name and document must be present if one of them is present')
    end
  end
end
