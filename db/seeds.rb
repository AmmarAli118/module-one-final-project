# seeds.rb
# PlaylistSong.destroy_all
# Playlist.destroy_all
# Song.destroy_all

# sample data #
#first seed
# rock_songs_playlist = get_playlist_by_search("rock")
# rap_songs_playlist = get_playlist_by_search("rap")
# country_songs_playlist = get_playlist_by_search("country")

#second seed
classical_songs_playlist = get_playlist_by_search("classical")
pop_songs_playlist = get_playlist_by_search("pop")
jazz_songs_playlist = get_playlist_by_search("jazz")

# SEED DATA

#  first seed
# seed_data(rock_songs_playlist, "rock")
# sleep(15)
# seed_data(rap_songs_playlist, "rap")
# sleep(15)
# seed_data(country_songs_playlist, "country")

#second seed

seed_data(classical_songs_playlist, "classical")
seed_data(pop_songs_playlist, "pop")
seed_data(jazz_songs_playlist, "jazz")
