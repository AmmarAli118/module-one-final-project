class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  # DOES NOT WORK
  def self.top_songs_by_feature(feature)
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
    song.title.truncate(30)
  end
end
