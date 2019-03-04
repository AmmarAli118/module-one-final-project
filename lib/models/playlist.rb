class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def duration
    #returns total duration of playlist
  end

  def self.generate(attributes, input_length)
    #search through Songs and narrow by each attribute (passed in CLI by tags)

    #   “acoustic” => “☐ acoustic”, “dancing” => “☐ dancing”, “energetic” => “☐ energetic”,
    #  “instrumental” => “☐ instrumental”, “live” => “☐ live”, “lyrical” => “☐ lyrical”,
    #  “fast” => “☐ fast”, “happy” => “☐ happy”, “melancholy” => “☐ melancholy”
    list = []
    query = []
    attributes.each do |attribute|
      if (attribute == "acoustic")
        query << "acousticness >= .6"
      elsif (attribute == "dancing")
        query << "danceability >= .6"
      elsif (attribute == "energetic")
        query << "energy >= .6"
      elsif (attribute == "live")
        query << "liveness >= .6"
      elsif (attribute == "lyrical")
        query << "speechiness >= .6"
      elsif (attribute == "fast")
        query << "tempo >= 125.0"
      elsif (attribute == "happy")
        query << "valence >= .6"
      elsif (attribute == "melancholy")
        query << "valence <= .4"
      else
        puts "Attribute Not Found"
      end
    end

    query.uniq!
    search = []
    while (query.length > 0)
      query_string = self.build_query(query)
      search = Song.where(query_string)
      if (search.length < input_length)
        puts "Expanding Query"
        index = rand(query.length)
        query.reject! { |q| query.index(q) == index }
      else
        break
      end
    end
    if (search.length <= 0)
      puts "Couldn't satisfy query"
    else
      search = search.sample(input_length)
      playlist = Playlist.create
      search.each do |song|
        playlist.songs << song
      end
      playlist.save
      return playlist
    end
  end

  def self.build_query(query)
    #helper method for generate
    query_string = ""
    query.each do |q|
      if (q != query[0])
        query_string += " AND "
      end

      query_string += q
    end
    query_string
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
end
