class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def duration
    #returns total duration of playlist
  end

  def self.generate(attributes, length)
    #search through Songs and narrow by each attribute (passed in CLI by tags)

    #   “acoustic” => “☐ acoustic”, “dancing” => “☐ dancing”, “energetic” => “☐ energetic”,
    #  “instrumental” => “☐ instrumental”, “live” => “☐ live”, “lyrical” => “☐ lyrical”,
    #  “fast” => “☐ fast”, “happy” => “☐ happy”, “melancholy” => “☐ melancholy”
    list = []
    attributes.each do |attribute|
      if (attribute == "acoustic")
        list.concat(Song.where("acousticness >= .5"))
      elsif (attribute == "dancing")
        list.concat(Song.where("danceability >= .5"))
      elsif (attribute == "energetic")
        list.concat(Song.where("instrumantalness >= .5"))
      elsif (attribute == "live")
        list.concat(Song.where("liveness >= .5"))
      elsif (attribute == "lyrical")
        list.concat(Song.where("lyrical >= .5"))
      elsif (attribute == "fast")
        list.concat(Song.where("speechiness >= .5"))
      elsif (attribute == "happy")
        list.concat(Song.where("valence >= .5"))
      elsif (attribute == "melancholy")
        list.concat(Song.where("valence <= .5"))
      else
        puts "Attribute Not Found"
      end
    end
    list = list.uniq.sample(length)
    playlist = Playlist.create()
    list.each { |song| playlist.songs << song }
    playlist
  end

  def display
    #Lists the songs
    #May yield to provide more details
    self.songs.each do |song|
      puts "#{song.id}. #{song.title}"
      yield(song)
    end
    nil
  end

  def display_with_details
    #puts the song details
    self.display do |song|
      song.display(false)
    end
    nil
  end

  def display_feature(feature)
    #puts the quality in a list "SongName: feature"
    self.songs.map do |song|
      puts "#{song.title}: #{song.send("#{feature}")}"
    end
  end

  def average(feature)
    #returns an average based on quality
    #only for float qualities, passed as symbols
    #eg: my_playlist.average(:danceability)
    return_value = self.songs.inject(0) { |sum, song| sum + song.send("#{feature}") }
    return_value / self.songs.length
  end

  def consistent(feature)
    #compares each value against the average, returns the average deviation
    #determines varience via squaring the difference, giving weight to extreme differences
    #the lower the value, the more consistent the quality
    avg = self.average(quality)
    return_value = self.songs.inject(0) do |sum, song|
      sum + (avg - song.send("#{feature}")).abs2
    end
    return_value = return_value / self.songs.length
    return_value * 100
  end
# ######### change index to playlist_index

  # add_song
  def add_song(song)
    self.songs << song
    song_in_playlist = self.playlist_songs.last
    song_in_playlist.playlist_index = self.playlist_songs.length
    song_in_playlist.save
  end

  # delete_song
  def delete_song(song)
    self.songs.delete(song)
  end

  # order_playlist
  def order_playlist
    # returns an array of songs in index order

  end

  # shuffle_song
  def shuffle_song

  end

  # update_playlist_index
  def update_playlist_index

  end

end
