# frozen_string_literal: true

class UpdateDefaultExperienceValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :experience, 'fresher'
  end
end
