class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def self.generate(attributes, length)
    #search through Songs and narrow by each attribute (passed in CLI by tags)

    #   “acoustic” => “☐ acoustic”, “dancing” => “☐ dancing”, “energetic” => “☐ energetic”,
    #  “instrumental” => “☐ instrumental”, “live” => “☐ live”, “lyrical” => “☐ lyrical”,
    #  “fast” => “☐ fast”, “happy” => “☐ happy”, “melancholy” => “☐ melancholy”
    list = []
    attributes.each do |attribute|
      if (attribute == "acoustic")
        list.concat(Song.where("acousticness >= 0.6"))
      elsif (attribute == "dancing")
        list.concat(Song.where("danceability >= 0.6"))
      elsif (attribute == "energetic")
        list.concat(Song.where("energy >= 0.6"))
      elsif (attribute == "chill")
        list.concat(Song.where("energy <= 0.4"))
      elsif (attribute == "live")
        list.concat(Song.where("liveness >= 0.6"))
      elsif (attribute == "lyrical")
        list.concat(Song.where("speechiness >= 0.6"))
      elsif (attribute == "fast")
        list.concat(Song.where("tempo >= 125"))
      elsif (attribute == "slow")
        list.concat(Song.where("tempo <= 115"))
      elsif (attribute == "happy")
        list.concat(Song.where("valence >= 0.6"))
      elsif (attribute == "melancholy")
        list.concat(Song.where("valence <= 0.4"))
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

  def get_data
    #return a hash including the name and relevant data
    return_hash = {name: self.name, length: self.songs.length, data: self.get_averages}
  end

  def get_averages
    #return a hash of averageable data
    relevant_columns = Song.columns.select do |col|
      col.type == :float
    end
    average_hash = {}
    relevant_columns.each do |col|
      average_hash[col.name] = self.average(col.name)
    end
    average_hash
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
    avg = self.average(feature)
    return_value = self.songs.inject(0) do |sum, song|
      sum + (avg - song.send("#{feature}")).abs2
    end
    return_value = return_value / self.songs.length
    return_value
  end

  def analyze_for_tags
    #compares the averages against deviation, returns tags which may describe playlist
    #weighs outliers appropriately -- eg: may not assign a "happy" tag to a playlist with nine ABBA songs and one Cradle of Filth
    tags = []
    tag_it(tags, :danceability, true, "dancing")
    tag_it(tags, :valence, true, "happy")
    tag_it(tags, :valence, false, "melancholy")
    tag_it(tags, :energy, true, "energetic")
    tag_it(tags, :energy, false, "chill")
    tag_it(tags, :instrumentalness, true, "instrumental")
    tag_it(tags, :speechiness, true, "lyrical")
    tag_it(tags, :acousticness, true, "unplugged")
    tag_it(tags, :liveness, true, "live")
    tags
  end

  def tag_it(array, feature, is_high, tag)
    #helper method for #analyze_for_tags
    if (feature == :tempo)
      if ((is_high && average(:tempo) >= 125) || (!is_high && average(:tempo) <= 115))
        array < tag
      end
    elsif ((self.average(feature) >= 0.6 && is_high) || (self.average(feature) <= 0.4 && !is_high))
      if (self.consistent(feature) <= 0.02)
        array << tag
      end
    end
  end
end
