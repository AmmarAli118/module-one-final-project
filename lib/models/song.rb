class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def increases_feature?(playlist:, feature:)
    #determines whether or not the addition of this song would increase the average of a playlist's audio feature
    avg = playlist.send("average(#{feature})")
    feat = self.send("#{feature}")
    return feat > avg
  end

  def add_to_playlist(playlist)
    playlist.add_song(self)
  end

# NOT FINISHED
  def song_data
    self.instance_values
  end
end
