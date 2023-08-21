# rubocop:disable all

class UpdateValidationIDb < ActiveRecord::Migration[6.1]
  def change
    change_column_null :conversations, :sender_id, false
    change_column_null :conversations, :recipient_id, false
    change_column_null :comments, :content, false
    change_column_null :create_job_roles, :name, false
    change_column_null :create_job_sectors, :name, false
    change_column_null :friendships, :requested_by_user_id, false
    change_column_null :job_comments, :content, false
    change_column_null :job_profiles, :title, false
    change_column_null :job_profiles, :user_id, false
    change_column_null :job_requirements, :job_title, false
    change_column_null :job_requirements, :job_description, false
    change_column_null :job_requirements, :vacancies, false
    change_column_null :job_requirements, :skills_required, false
    change_column_null :job_requirements, :job_sector_id, false
    change_column_null :job_requirements, :job_role_id, false
    change_column_null :job_roles, :name, false
    change_column_null :job_sectors, :name, false
    change_column_null :messages, :conversation_id, false
    change_column_null :messages, :sender_id, false
    change_column_null :messages, :recipient_id, false
    change_column_null :messages, :body, false
    change_column_null :notifications, :sender_id, false
    change_column_null :notifications, :body, false
    change_column_null :notifications, :recipient_id, false
    change_column_null :posts, :content, false
    change_column_null :users, :username, false
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
  end
end
