class UpdatePlaylistSongsTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :playlist_songs, :index, :playlist_index
  end
end
