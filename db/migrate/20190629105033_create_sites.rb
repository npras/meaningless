class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :domain
      t.integer :discussions_count
      t.integer :comments_count

      t.timestamps
    end

    add_index :sites, :domain, unique: true
  end
end
