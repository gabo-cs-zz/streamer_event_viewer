class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :streamer_name
      t.integer :event_type
      t.string :viewer_name

      t.timestamps
    end

    add_foreign_key :events, :streamers, column: :streamer_name, primary_key: :name
    add_index :events, :streamer_name
  end
end
