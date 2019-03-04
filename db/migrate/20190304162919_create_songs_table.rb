class CreateSongsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string  :title
      t.string  :artist
      t.string  :spotify_artist_id
      t.string  :album
      t.string  :spotify_album_id
      t.integer :duration
      t.integer :key
      t.integer :mode
      t.float   :acousticness
      t.float   :danceability
      t.float   :energy
      t.float   :instrumentalness
      t.float   :liveness
      t.float   :speechiness
      t.float   :valence
      t.float   :tempo
    end
  end
end
