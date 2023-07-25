# frozen_string_literal: true

class AddUserIdToJobRequirements < ActiveRecord::Migration[6.1]
  def change
    add_reference :job_requirements, :user, null: false, foreign_key: true
  end
end
