class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :domain
      t.integer :discussions_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end

    add_index :sites, :domain, unique: true
  end
end
