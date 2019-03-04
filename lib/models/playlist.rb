class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def duration
    #returns total duration of playlist
  end

  def display(quality)
    #puts the quality in a list "SongName: Quality"
    self.songs.map do |song|
      puts "#{song.title}: #{song.send("#{quality}")}"
    end
  end

  def average(quality)
    #returns an average based on quality
    #only for float qualities, passed as symbols
    #eg: my_playlist.average(:danceability)
    ret = self.songs.inject(0) { |sum, song| sum + song.send("#{quality}") }
    ret / self.songs.length
  end

  def consistent(quality)
    #compares each value against the average, returns the average deviation
    #determines varience via squaring the difference, giving weight to extreme differences
    #the lower the value, the more consistent the quality
    avg = self.average(quality)
    ret = self.songs.inject(0) do |sum, song|
      sum + (avg - song.send("#{quality}")).abs2
    end
    ret = ret / self.songs.length
    ret * 100
  end

  def average_danceability
    self.average(:danceability)
  end

  def average_energy
    self.average(:energy)
  end

  def average_acousticness
    self.average(:acousticness)
  end

  def average_liveness
    self.average(:liveness)
  end

  def average_instrumentalness
    self.average(:instrumentalness)
  end

  def average_valence
    self.average(:valence)
  end

  def average_tempo
    self.average(:tempo)
  end

  def average_speechiness
    self.average(:speechiness)
  end
end
