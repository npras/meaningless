class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.text :body
      t.string :ip_address
      t.string :user_agent
      t.string :referrer
      t.references :site, null: false, foreign_key: true
      t.references :discussion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
