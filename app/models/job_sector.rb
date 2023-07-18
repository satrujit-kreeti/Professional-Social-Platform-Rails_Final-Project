class JobSector < ApplicationRecord
    has_many :job_roles, dependent: :destroy
end
