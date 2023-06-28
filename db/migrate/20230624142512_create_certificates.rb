class CreateCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.blob :document

      t.timestamps
    end
  end
end
