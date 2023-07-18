class AddStatusToJobRequirements < ActiveRecord::Migration[6.1]
  def change
    add_column :job_requirements, :status, :string, default: 'pending'
  end
end
