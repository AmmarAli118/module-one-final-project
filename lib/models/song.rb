class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def top_songs_by_feature(feature)
    #returns top ten by feature
    Song.all.order(feature, :desc)[0..9]
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
