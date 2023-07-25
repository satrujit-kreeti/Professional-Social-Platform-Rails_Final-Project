class ModifyUsersCvDownloadPermission < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :cv_download_permission, :string, default: 'connections', null: false
  end
end
