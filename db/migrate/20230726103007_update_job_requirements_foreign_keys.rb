# frozen_string_literal: true

class UpdateJobRequirementsForeignKeys < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :job_requirements, :job_roles
    add_foreign_key :job_requirements, :job_roles, on_delete: :nullify

    remove_foreign_key :job_requirements, :job_sectors
    add_foreign_key :job_requirements, :job_sectors, on_delete: :nullify
  end
end
