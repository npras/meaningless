class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :remember_token, unique: true
  end
end
