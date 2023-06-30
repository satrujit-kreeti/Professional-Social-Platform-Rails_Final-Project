class MakeCertificateIdNullableInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :certificate_id, true
  end
end
