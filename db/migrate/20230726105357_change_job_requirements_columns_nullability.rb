# frozen_string_literal: true

class ChangeJobRequirementsColumnsNullability < ActiveRecord::Migration[6.1]
  def change
    change_column_null :job_requirements, :job_role_id, true
    change_column_null :job_requirements, :job_sector_id, true
  end
end
