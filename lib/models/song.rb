class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

<<<<<<< HEAD
  def self.top_songs_by_feature(feature, increment)
=======
  def self.top_songs_by_feature(feature)
>>>>>>> 59b7b105c8d729cc4b8481818d6d43cacddfc54b
    #returns top ten by feature
    list = []
    if (increment)
      list = self.order(feature)
    else
      list = self.order("#{feature} DESC")
    end
    list
  end

  def add_to_playlist(playlist)
    playlist.add_song(self)
  end

  def song_data
    self.instance_values
  end

  def display(include_title = true)
    #puts the song details
    self.attributes.map do |name, value|
      unless (!include_title && name == :title)
        puts "     #{name}: #{value}"
      end
    end
    puts "--------------------------------------------"
  end

  def increases_feature?(playlist:, feature:)
    #determines whether or not the addition of this song would increase the average of a playlist's audio feature
    #Deprecated -- probably in purgatory
    avg = playlist.send("average(#{feature})")
    feat = self.send("#{feature}")
    return feat > avg
  end
end
