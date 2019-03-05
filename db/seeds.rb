# seeds.rb
# authenticate

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
      acousticness: features.acousticness,
      danceability: features.danceability,
      energy: features.energy,
      instrumentalness: features.instrumentalness,
      liveness: features.liveness,
      speechiness: features.speechiness,
      valence: features.valence,
      tempo: features.tempo,
    )
  end
end

# need to add method for creating playlists
# p =  Playlist.find_or_create_by("sample_rock_playlist")

# sample data #
rock_songs_playlist = get_playlist_by_search("rock").first

# SEED DATA
seed_data(rock_songs_playlist, "rock")
