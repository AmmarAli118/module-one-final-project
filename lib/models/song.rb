class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def self.top_songs_by_feature(feature, increment, num)
    #returns top ten by feature
    list = []
    if (increment)
      list = self.order("#{feature} DESC")
    else
      list = self.order(feature)
    end
    list[0...num].map { |s| puts "#{s.title} #{s.send("#{feature}")}" }
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
