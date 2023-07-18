class CreateCreateJobRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :create_job_roles do |t|
      t.string :name
      t.references :job_sector, null: false, foreign_key: true

      t.timestamps
    end
  end
end
