#class for instance of playlist menu to display in cli
  #-------------
  #songs section
  #-------------
  def songs
    make_large_box("Songs\n1. View Top Songs By Tag\n2. Find Song\n3. Back\n")

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view top songs by tag"
        view_top_songs_by_tag
      when "2", "find song"
        find_song
    end
  end

  def view_top_songs_by_tag
    tags = ["acoustic", "dancing", "energetic", "instrumental", "live", "lyrical", "fast", "happy", "melancholy", "slow", "chill"]

    make_large_box("View Top Songs By Tag\nEnter tag to view top 10 songs: \n- acoustic  - dancing  - energetic\n- instrumental  - live   - lyrical\n- fast   - happy   - melancholy\n- slow    - chill\n")

    input = gets.chomp!
    input.downcase!

    tags.each do | tag |
      if input == tag
        # top_songs_string = "Top Songs for #{tag}: \n"
        # top_songs_array = []
        # Song.top_songs_by_feature(tag) do | song |
        #   top_songs_array << "#{song.title}"
        # end
        # top_songs_string += columnize_song_name_array(top_songs_array, true, 1)
        # make_large_box(top_songs_string)
        gets.chomp!
      end
    end
  end

  #method for displayling a specific song
  def display_song(song)
    display_song_string = "Song: #{song.title}\t\tArtist: #{song.artist}\t\tAlbum: #{song.album}\n"
    display_song_string += "Genre: #{song.genre}\t\tKey: #{key_letter(song.key)} #{song_key(song.mode)}\n\n"
    song_data = {"acousticness" => song.acousticness, "danceability" => song.danceability,
       "energy" => song.energy, "instrumentalness" => song.instrumentalness, "liveness" => song.liveness,
       "speechiness" => song.speechiness, "valence" => song.valence, "tempo" => song.tempo}
    display_song_string += get_bargraph(song_data, "")
    #make_large_box(display_song_string)
    make_versatile_box(display_song_string)
    gets.chomp!
  end

  #methods for finding a song by search
  def find_song
    make_large_box("Find Song\nEnter name of song:")

    input = gets.chomp!
    input.downcase!
    #search for playlist
    result = song_search(input)
    if result != 0
      display_song(result)
    end
  end
  #creates a formatted string of possible songs based on user input
  def song_search(input)
    songs_string = "Enter number of the song you want: \n"

    i = 1
    possible_songs = Song.where("title LIKE '%#{input}%'")
    if possible_songs.empty?
      playlist_string = "No results found."
      make_large_box(playlist_string)
      gets.chomp!
      return 0
    end
    possible_songs.each do | song |
      songs_string += "#{i}. #{song.title} - #{song.artist}\n"
      i += 1
    end

    make_large_box(songs_string)
    new_input = gets.chomp!
    new_input.downcase!

    possible_songs[(new_input.to_i - 1)]
  end
