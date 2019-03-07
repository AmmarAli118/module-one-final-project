class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

<<<<<<< HEAD
  def self.top_songs_by_feature(feature, increment)
=======
  # DOES NOT WORK
  def self.top_songs_by_feature(feature)
>>>>>>> 6ba9eee6dfd82a21adc543ffa931c2c42491e8a0
    #returns top ten by feature
    # ----------
    # Song.all.order(feature, :desc)[0..9]
    # ------------
  end

  # add_to_playlist
  def add_to_playlist(playlist)
    playlist.add_song(self)
  end

  # short_title
  def short_title
    self.title.truncate(30)
  end
end
