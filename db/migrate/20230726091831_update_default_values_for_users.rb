# frozen_string_literal: true

class UpdateDefaultValuesForUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :linkedin_profile, nil
    change_column_default :users, :experience, ''
    change_column_default :users, :current_organization, ''
  end
end
