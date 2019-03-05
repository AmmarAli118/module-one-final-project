class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  def self.generate(attributes, input_length)
    #search through Songs and narrow by each attribute (passed in CLI by tags)

    #   “acoustic” => “☐ acoustic”, “dancing” => “☐ dancing”, “energetic” => “☐ energetic”,
    #  “instrumental” => “☐ instrumental”, “live” => “☐ live”, “lyrical” => “☐ lyrical”,
    #  “fast” => “☐ fast”, “happy” => “☐ happy”, “melancholy” => “☐ melancholy”

    list = []
    query = []
    # Creates a SQL query based on given tags
    attributes.each do |attribute|
      if (attribute == "acoustic")
        query << "acousticness >= 0.6"
      elsif (attribute == "dancing")
        query << "danceability >= 0.6"
      elsif (attribute == "energetic")
        query << "energy >= 0.6"
      elsif (attribute == "chill")
        query << "energy <= 0.4"
      elsif (attribute == "live")
        query << "liveness >= 0.6"
      elsif (attribute == "lyrical")
        query << "speechiness >= 0.6"
      elsif (attribute == "fast")
        query << "tempo >= 125.0"
      elsif (attribute == "slow")
        query << "tempo <= 115.0"
      elsif (attribute == "happy")
        query << "valence >= 0.6"
      elsif (attribute == "melancholy")
        query << "valence <= 0.4"
      else
        puts "Attribute Not Found"
      end
    end

    query.uniq!
    search = []

    query_string = self.build_query(query)
    search.concat(Song.where(query_string))
    search.uniq!
    query_size = query.length
    while (query_size > 0)
      if (search.length < input_length)
        #if the full query is not enough, find largest possible combination
        query_size -= 1
        new_queries = query.combination(query_size).to_a
        new_queries.each do |query|
          query_string = self.build_query(query)
          search.concat(Song.where(query_string))
          search.uniq!
        end
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
    #currently ignores averages with deviations above 5%
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
      if (self.consistent(feature) <= 0.05)
        array << tag
      end
    end
  end

  def optimize(feature, more_or_less)
    #improve the playlist based on the feature
    #should earn the playlist the appropriate tag
    #if the playlist already has the tag, it should raise the average and lower inconsistencies

    avg = average(feature)
    self.delete_song(self.songs.order(feature).first)
  end

  def needs_more_cowbell
    return !self.songs.includes(Song.find(name: "Don't Fear The Reaper"))
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
