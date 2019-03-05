#Spotify Helpers

# score
def score(value)
  # returns a percent value of a float between 0 and 1
  "#{(value * 100).round(2)}%"
end

# key_letter
def key_letter(key_num)
 keys = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
 keys[key_num]
end

# song_key
def song_key(key_mode)
 key_mode == 1 ? "Major" : "Minor"
end

# get_playlist_by_search
def get_playlist_by_search(search_term)
  # authenticate
  RSpotify.authenticate(API_KEY, API_SECRET)
  # returns first playlist matching search term
  RSpotify::Playlist.search(search_term, limit: 1).first
end

# seed_data
def seed_data(spotify_playlist, genre)
  # initialize new Playlist in database
  db_playlist = Playlist.create(name: "#{genre.capitalize} Playlist")

  # iterate through each Track object
  spotify_playlist.tracks.each do |track|

    # create instance variables for legibility
    name = track.name
    artist = track.artists.first.name
    album = track.album.name
    features = track.audio_features

    # creates new song instance with api data
    song = Song.find_or_create_by(
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
      tempo: features.tempo
    )
    # add new song to playlist
    song.add_to_playlist(db_playlist)
  end
end
