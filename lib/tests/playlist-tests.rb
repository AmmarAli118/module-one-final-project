
def p_generate_test
  # puts "Playlist.generate generates a new playlist."
  Playlist.destroy_all("name = 'test 1' OR name = 'test 2' OR name = 'test 3'")
  test_playlist_1 = Playlist.generate("test 1", ["happy"], 20)
  test_playlist_2 = Playlist.generate("test 2", ["country", "melancholy", "chill"], 30)
  test_playlist_3 = Playlist.generate("test 3", ["jazz", "country", "slow", "acoustic"], 25)
  puts "Playlist tests"

  puts "1. The playlist is of a proper length."
  puts test_playlist_1.songs.length == 20, test_playlist_2.songs.length == 30, test_playlist_3.songs.length == 25

  puts "2. When genres are specified, playlist contains only those genres"
  puts test_playlist_2.genres.length == 1 && test_playlist_2.genres.include?("classical")
  puts test_playlist_3.genres.length == 2 && test_playlist_3.genres.include?("jazz") && test_playlist_3.genres.include?("country")
  puts "3. When other tags are specified, playlist averages should highlight this, Though not neccessarily meet all the specifications"
  puts test_playlist_1.feature_is_sufficient?(:valence, true)
  puts test_playlist_2.feature_is_sufficient?(:valence, false) && test_playlist_2.feature_is_sufficient?(:energy, false)

  sad_country = Song.where("valence <= .5").select { |song| song.genre == "country" }
  chill_country = Song.where("energy <= .5").select { |song| song.genre == "country" }
  sad_country_and_chill_country = sad_country.concat(chill_country).uniq!
  sad_chill_country = sad_country_and_chill_country.select { |s| sad_country.include?(s) && chill_country.include?(s) }
  rejects = sad_country_and_chill_country.select { |song| !sad_country.include?(song) || !chill_country.include?(song) }

  sad_chill_country.each { |song| puts test_playlist_2.songs.include?(song) }

  puts test_playlist_3.feature_is_sufficient?(:tempo, false) && test_playlist_3.feature_is_sufficient?(:acousticness, true)
end

def p_optimize_test
  test_playlist_1 = Playlist.generate("test 1", ["happy"], 20)
  test_playlist_2 = Playlist.generate("test 2", ["country", "melancholy", "chill"], 30)
  test_playlist_3 = Playlist.generate("test 3", ["jazz", "country", "slow", "acoustic"], 25)
end
