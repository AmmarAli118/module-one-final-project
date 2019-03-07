
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
  Playlist.where("name = 'test 1' OR name = 'test 2' OR name = 'test 3' OR name = 'test 4' OR name = 'test 5'").destroy_all
  test_1 = Playlist.generate("test 1", ["happy"], 20)
  test_2 = Playlist.generate("test 2", ["melancholy", "chill"], 30)
  test_3 = Playlist.generate("test 3", ["rock", "slow", "acoustic"], 25)
  test_4 = Playlist.generate("test 4", ["chill", "live", "happy", "lyrical", "slow", "acoustic"], 25)
  test_5 = Playlist.generate("test 5", ["country", "slow", "acoustic"], 25)

  puts "Optimize raises or lowers the average"
  old_avg = test_1.average(:valence)
  test_1.optimize(:valence, false)
  puts old_avg > test_1.average(:valence)

  old_avg = test_2.average(:energy)
  test_2.optimize(:energy, true)
  puts old_avg < test_2.average(:energy)

  old_avg = test_3.average(:tempo)
  test_3.optimize(:tempo, true)
  puts old_avg < test_3.average(:tempo)

  old_avg = test_4.average(:instrumentalness)
  test_4.optimize(:instrumentalness, true)
  puts old_avg < test_4.average(:instrumentalness)

  old_avg = test_5.average(:acousticness)
  test_5.optimize(:acousticness, false)
  puts old_avg > test_5.average(:acousticness)

  puts ("Optimize never selects songs of the wrong genre")
  old_genres = test_2.genres
  test_2.optimize(:acousticness, true)
  test_2.optimize(:energy, false)
  test_2.optimize(:valence, false)
  test_2.optimize(:liveness, false)
  puts test_2.genres == old_genres

  old_genres = test_5.genres
  test_5.optimize(:acousticness, true)
  test_5.optimize(:energy, true)
  test_5.optimize(:valence, false)
  test_5.optimize(:liveness, false)
  puts test_5.genres.sort == old_genres.sort

  puts ("Optimize never changes length")
  3.times do
    test_3.optimize(:acousticness, false, 0.5)
    puts test_3.songs.length == 25

    test_5.optimize(:tempo, true, 0.5)
    puts test_5.songs.length == 25
  end
  puts ("Optimize doesn't replace more songs than it should")
  old_songs = test_1.songs
  test_1.optimize(:valence, false, 0.5)
  difference = (old_songs - test_1.songs) | (test_1.songs - old_songs)
  puts difference.length <= 10

  old_songs = test_2.songs
  test_2.optimize(:danceability, false, 0.3333)
  difference = (old_songs - test_2.songs) | (test_2.songs - old_songs)
  puts difference.length <= 10

  old_songs = test_4.songs
  test_4.optimize(:tempo, false, 0.8)
  difference = (old_songs - test_4.songs) | (test_4.songs - old_songs)
  puts difference.length <= 20
end
