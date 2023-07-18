class CreateCreateJobSectors < ActiveRecord::Migration[6.1]
  def change
    create_table :create_job_sectors do |t|
      t.string :name

      t.timestamps
    end
  end
end
