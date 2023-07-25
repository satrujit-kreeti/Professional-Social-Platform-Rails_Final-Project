# frozen_string_literal: true

class ChangeRelevantSkillNotificationToBooleanInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :relevant_skill_notification, :boolean, default: true
  end
end
