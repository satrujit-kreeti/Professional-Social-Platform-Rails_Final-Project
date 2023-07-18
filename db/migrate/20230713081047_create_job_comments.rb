class CreateJobComments < ActiveRecord::Migration[6.1]
  def change
    create_table :job_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job_requirement, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
