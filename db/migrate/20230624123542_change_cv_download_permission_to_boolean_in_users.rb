class ChangeCvDownloadPermissionToBooleanInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :cv_download_permission, :boolean, default: false
  end

end
