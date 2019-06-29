class CreateDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions do |t|
      t.string :url
      t.string :title
      t.integer :comments_count
      t.integer :likes, default: 0
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end

    add_index :discussions, :url, unique: true
  end
end
