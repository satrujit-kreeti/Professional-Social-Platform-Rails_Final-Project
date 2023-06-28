class RemoveCertificateIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :certificate_id
  end
end
