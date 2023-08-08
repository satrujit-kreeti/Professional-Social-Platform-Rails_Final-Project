# frozen_string_literal: true

class JobRequirement < ApplicationRecord
  belongs_to :job_sector
  belongs_to :job_role
  has_many :job_comments
  belongs_to :user

  validates :job_title, presence: true
  validates :job_description, presence: true
  validates :vacancies, presence: true
  validates :skills_required, presence: true

  enum status: { pending: 'pending', approved: 'approved', rejected: 'rejected' }
end
