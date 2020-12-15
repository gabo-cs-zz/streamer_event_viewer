class CreateStreamers < ActiveRecord::Migration[6.0]
  def change
    create_table :streamers do |t|
      t.string :name, null: false
      t.string :status
      t.index :name, unique: true

      t.timestamps
    end
  end
end
