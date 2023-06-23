class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :linkedin_profile
      t.string :qualification
      t.string :experience
      t.string :current_organization
      t.string :string
      t.string :skills
      t.boolean :relevant_skill_notification
      t.string :profile_photo
      t.string :cv
      t.string :cv_download_permission

      t.timestamps
    end
  end
end
