class JobRole < ApplicationRecord
  belongs_to :job_sector
  validates :name, presence: true
end
