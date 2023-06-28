class MakeCertificateIdNullableInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :certificate_id, :bigint, null: true
  end
end
