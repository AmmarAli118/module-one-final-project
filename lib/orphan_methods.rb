# Song methods
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

# Playlist methods

  def analyze_for_tags
    #compares the averages against deviation, returns tags which may describe playlist
    #weighs outliers appropriately -- eg: may not assign a "happy" tag to a playlist with nine ABBA songs and one Cradle of Filth
    #currently ignores averages with deviations above 5%
    #not in use -- but may be valuable
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

  def get_deviation(feature)
    #compares each value against the average, returns the average deviation
    #determines varience via squaring the difference, giving weight to extreme differences
    #the lower the value, the more consistent the quality
    #This is not in use (yet), but hold on in case we need it
    avg = self.average(feature)
    return_value = self.songs.inject(0) do |sum, song|
      sum + (avg - song.send("#{feature}")).abs2
    end
    return_value = return_value / self.songs.length
    return_value
  end

  def tag_it(array, feature, more, tag)
    #helper method for #analyze_for_tags
    #not in use -- may be needed
    if (feature_is_sufficient?(feature, more) && self.get_deviation(feature) <= 0.05)
      array << tag
    end
  end

  def needs_more_cowbell
    #Untested. Possibly Dangerous
    return !self.songs.includes(Song.find(name: "Don't Fear The Reaper"))
  end

  def display
    #Lists the songs
    #May yield to provide more details
    #Mostly used for testing
    self.songs.each do |song|
      puts "#{song.id}. #{song.title}"
    end
    nil
  end

  def display_with_details
    #puts the song details
    #mostly used for testing
    self.songs.each do |song|
      song.display(false)
    end
    nil
  end

  def display_feature(feature)
    #puts the quality in a list "SongName: feature"
    #mostly used for testing
    self.songs.map do |song|
      puts "#{song.title}: #{song.send("#{feature}")}"
    end
  end
