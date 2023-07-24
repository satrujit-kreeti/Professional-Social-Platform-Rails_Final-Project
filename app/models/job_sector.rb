class JobSector < ApplicationRecord
    has_many :job_roles, dependent: :destroy
    accepts_nested_attributes_for :job_roles, allow_destroy: true
    validates :name, presence: true
    validates :job_roles, presence: { message: 'must have at least one job role' }

    before_save :mark_blank_job_role_for_destruction

    def mark_blank_job_role_for_destruction
      job_roles.each do |job_role|
        if job_role.name.blank?
          job_role.mark_for_destruction
        end
      end
    end
end
