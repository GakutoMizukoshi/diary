class CreateDiaries < ActiveRecord::Migration[5.0]
  def change
    create_table :diaries do |t|
      t.references :user, foreign_key: true
      t.integer :send_id
      t.string :content
      t.string :canvas

      t.timestamps
    end
  end
end
