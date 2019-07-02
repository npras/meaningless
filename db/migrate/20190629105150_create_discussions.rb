class CreateDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions do |t|
      t.string :url
      t.integer :comments_count, default: 0
      t.integer :likes, default: 0
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end

    add_index :discussions, [:site_id, :url], unique: true
  end
end
