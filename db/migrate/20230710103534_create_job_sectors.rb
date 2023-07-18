class CreateJobSectors < ActiveRecord::Migration[6.1]
  def change
    create_table :job_sectors do |t|
      t.string :name

      t.timestamps
    end
  end
end
