class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

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
    avg = playlist.send("average(#{feature})")
    feat = self.send("#{feature}")
    return feat > avg
  end

  def add_to_playlist(playlist)
    playlist.add_song(self)
  end

  def song_data
    self.instance_values
  end
end
