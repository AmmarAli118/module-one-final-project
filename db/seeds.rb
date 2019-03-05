# seeds.rb
<<<<<<< HEAD
require_rel "../config/environment.rb"
# authenticate
def authenticate
  # Authenticate RSpotify Wrapper
  RSpotify.authenticate(API_KEY, API_SECRET)
end
=======
>>>>>>> 7f7bbe7dd592d9c54cdc90926603b98d39afdbdd

# get_playlist_by_search
def get_playlist_by_search(search_term)
  RSpotify.authenticate(API_KEY, API_SECRET)
  RSpotify::Playlist.search(search_term, limit: 1)
end

# seed_data
def seed_data(playlist, genre)
  playlist.tracks.each do |track|
    # create instance variables for legibility
    name = track.name
    artist = track.artists.first.name
    album = track.album.name
    features = track.audio_features
    # creates new song instance with api data
    Song.find_or_create_by(
      title: name,
      artist: artist,
      album: album,
      genre: genre,
      duration: features.duration_ms,
      key: features.key,
      mode: features.mode,
<<<<<<< HEAD
      acousticness: acousticness,
      danceability: danceability,
      energy: energy,
      instrumentalness: instrumentalness,
      liveness: liveness,
      speechiness: speechiness,
      valence: valence,
      tempo: tempo,
      genre: genre,
=======
      acousticness: features.acousticness,
      danceability: features.danceability,
      energy: features.energy,
      instrumentalness: features.instrumentalness,
      liveness: features.liveness,
      speechiness: features.speechiness,
      valence: features.valence,
      tempo: features.tempo
>>>>>>> 7f7bbe7dd592d9c54cdc90926603b98d39afdbdd
    )
  end

end

<<<<<<< HEAD
authenticate
=======
# need to add method for creating playlists
# p =  Playlist.find_or_create_by("sample_rock_playlist")

>>>>>>> 7f7bbe7dd592d9c54cdc90926603b98d39afdbdd
# sample data #
rock_songs_playlist = get_playlist_by_search("rock").first

# SEED DATA
<<<<<<< HEAD

=======
>>>>>>> 7f7bbe7dd592d9c54cdc90926603b98d39afdbdd
seed_data(rock_songs_playlist, "rock")
