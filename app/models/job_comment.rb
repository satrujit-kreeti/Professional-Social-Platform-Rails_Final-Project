class JobComment < ApplicationRecord
    belongs_to :user
    belongs_to :job_requirement
    validates :content, presence: true
end