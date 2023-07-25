# frozen_string_literal: true

class JobRequirement < ApplicationRecord
  belongs_to :job_sector
  belongs_to :job_role
  has_many :job_comments

  enum status: { pending: 'pending', approved: 'approved', rejected: 'rejected' }
end
