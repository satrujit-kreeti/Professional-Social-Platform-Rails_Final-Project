# frozen_string_literal: true

class CreateJobRequirements < ActiveRecord::Migration[6.1]
  def change
    create_table :job_requirements do |t|
      t.string :job_title
      t.text :job_description
      t.integer :vacancies
      t.string :skills_required
      t.references :job_sector, null: false, foreign_key: true
      t.references :job_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
