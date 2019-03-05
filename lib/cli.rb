class CLI
  attr_accessor :username
  #box = TTY::Box.frame(width: 30, height:10, title: {top_left: "TITLE"})

  def run
    exit_flag = false

    welcome_screen

    while !exit_flag
      main_menu
      input = gets.chomp!
      input.downcase!
      case(input)
        when "1", "playlists"
          playlists
        when "2", "songs"
          songs
        when "3", "exit"
          exit_flag = true
        # when "4", "exit"
        #   exit_flag = true
      end
    end
  end

  def make_box(text)
    system "clear"
    box = TTY::Box.frame(width: 50, height:10, border: :thick, title: {top_left: "SPOPTIMIZER"},
      style: {
        fg: :white,
        bg: :black,
        border: {
          fg: :green,
          bg: :black
        }
        }) do
          text
        end
    print box
    box
  end

  def make_large_box(text)
    system "clear"
    box = TTY::Box.frame(width: 100, height:15, border: :thick, title: {top_left: "SPOPTIMIZER"},
      style: {
        fg: :white,
        bg: :black,
        border: {
          fg: :green,
          bg: :black
        }
        }) do
          text
        end
    print box
    box
  end

  def make_versatile_box(text)
    new_line_count = text.count("\n")
    new_line_count += 3
    longest_line = 0
    text.split("\n").each do | line |
      if line.length > longest_line
        longest_line = line.length
      end
    end

    system "clear"
    box = TTY::Box.frame(width: longest_line, height: new_line_count, border: :thick, title: {top_left: "SPOPTIMIZER"},
      style: {
        fg: :white,
        bg: :black,
        border: {
          fg: :green,
          bg: :black
        }
        }) do
          text
        end
    print box
    box
  end

  def welcome_screen

    make_box("\n\n\nPlease enter your name:")

    self.username = gets.chomp!
    if self.username.downcase == "lane"
      black_eyed_peas
    end
  end

  # Playlist menu and options

  def playlists
    make_box("Playlists\n1. Generate Playlist\n2. View All Playlists\n3. Find Playlist\n4. Back")

    input = gets.chomp!
    input.downcase!
    case (input)
    when "1", "generate playlist"
      generate_playlist
    when "2", "view all playlists"
      view_all_playlists
    when "3", "find playlist"
      find_playlist
      # when "4", "back"
      #   exit_flag = true
    end
  end

  def generate_playlist
    make_box("Generate Playlist\nEnter name for playlist:\nEnter number of songs:")

    playlist_name = gets.chomp!
    playlist_size = gets.chomp!
    array_of_tags = tag_selection
    #new_playlist = generate_new_playlist
    new_playlist = Playlist.generate(playlist_name, array_of_tags, playlist_size.to_i)
    input = gets.chomp!
    display_playlist(new_playlist)

  end

  def tag_selection
    input = ""
    input_done = false

    tags = {"acoustic" => "☐ acoustic", "dancing" => "☐ dancing", "energetic" => "☐ energetic",
    "instrumental" => "☐ instrumental", "live" => "☐ live", "lyrical" => "☐ lyrical",
    "fast" => "☐ fast", "happy" => "☐ happy", "melancholy" => "☐ melancholy", "slow" => "☐ slow",
    "chill" => "☐ chill"}

    array_of_tags = []

    while (!input_done)
      tag_string = "Generate Playlist\nEnter tags for playlist seperated by a space:\nType 'submit' when finished.\n#{tags["acoustic"]}  #{tags["dancing"]}  #{tags["energetic"]}\n#{tags["instrumental"]}  #{tags["live"]}  #{tags["lyrical"]}\n#{tags["fast"]}  #{tags["happy"]}  #{tags["melancholy"]}\n#{tags["slow"]}  #{tags["chill"]}"

      make_box(tag_string)

      input = gets.chomp!
      input.downcase!
      input_array = input.split
      input_array.each do |word|
        if word == "submit"
          tags.each do |key, value|
            if value[0] == "☑"
              array_of_tags << key
            end
          end
          make_box(array_of_tags.uniq.to_s)
          input_done = true
        else
          tags[word] = "☑ #{word}"
          word == "fast" ? tags["slow"] = "☐ slow" : 0
          word == "slow" ? tags["fast"] = "☐ fast" : 0
          word == "energetic" ? tags["chill"] = "☐ chill" : 0
          word == "chill" ? tags["energetic"] = "☐ energetic" : 0
          word == "happy" ? tags["melancholy"] = "☐ melancholy" : 0
          word == "melancholy" ? tags["happy"] = "☐ happy" : 0
        end
      end
    end
    array_of_tags
  end

  def display_all_playlist
    all_playlist = Playlist.all
    all_playlist_string = ""
    i = 1
    all_playlist.each do | playlist |
      all_playlist_string += "#{i}.#{playlist.name}\n"
      i += 1
    end

    all_playlist_string
  end

  def delete_playlist
    all_playlist_string = "Enter Number To Delete: \n"
    all_playlist_string += display_all_playlist
    all_playlist_string += "--------------\n"
    make_large_box(all_playlist_string)
    input = gets.chomp!

    i = 1
    (Playlist.all).each do | playlist |
      if input.to_i == i
        Playlist.delete(playlist)
        break
      end
      i += 1
    end
  end

  def view_all_playlists
    all_playlist = Playlist.all
    # all_playlist_string = "Enter Number To View: \n"
    # i = 1
    # all_playlist.each do | playlist |
    #   all_playlist_string += "#{i}.#{playlist.name}\n"
    #   i += 1
    # end
    all_playlist_string = "Enter Number To View: \n"
    all_playlist_string += display_all_playlist
    all_playlist_string += "--------------\n"
    all_playlist_string += "a) Delete a Playlist"

    make_large_box(all_playlist_string)
    input = gets.chomp!
    if input == "a" || input == "delete a playlist"
      delete_playlist
    end

    i = 1
    all_playlist.each do | playlist |
      if input.to_i == i
        display_playlist(playlist)
        break
      end
      i += 1
    end
  end

  def find_playlist
    make_box("Find Playlist\nEnter name of playlist:")

    input = gets.chomp!
    input.downcase!
    #search for playlist
    playlist_array = ["test song1", "test_song2"]
    display_playlist(playlist_array)
  end

  def display_playlist(playlist)
    playlist_data = playlist.get_data

    #print_bargraph(playlist_data[:data], playlist_data[:name])
    playlist_song_array = []

    playlist.songs.each do | song |
      playlist_song_array << "#{song.title} - #{song.artist}"
    end

    songs_string = print_playlist_songs(playlist_song_array, playlist_data[:name])
    songs_string += "\n\na)Add Song  b) Remove Song c) Optimize Playlist d) Data e) Reorder\n"
    #make_large_box(songs_string)
    make_versatile_box(songs_string)

    input = gets.chomp!
    input.downcase!
    if input == "a" || input == "add song"
      add_song_to_playlist(playlist)
    elsif input == "b" || input == "remove song"
      remove_song_from_playlist(playlist)
    elsif input == "c" || input == "optimize playlist"
      optimize_playlist(playlist)
    elsif input == "d" || input == "data"
      #display_data(playlist)
      print_bargraph(playlist_data[:data], playlist_data[:name])
    elsif input == "e" || input == "reorder"
      reorder_playlist(playlist)
    end
  end

  def display_data(playlist)

  end

  def reorder_playlist(playlist)

  end

  def add_song_to_playlist(playlist)
    playlist_data = playlist.get_data
    playlist_song_array = []
    playlist.songs.each do | song |
      playlist_song_array << "#{song.title}"
    end

    songs_string = print_playlist_songs(playlist_song_array, playlist_data[:name])
    songs_string += "\nEnter name of song you want to add: \n"
    make_large_box(songs_string)
    input = gets.chomp!
    input.downcase!

    new_song = song_search(input)
    playlist.add_song(new_song)
    # new_song = Song.find_by(name: input)
    #possible_songs = Song.where("title LIKE '%#{input}%'")
  end

  def song_search(input)
    songs_string = "\nEnter number of the song you want to add: \n"

    i = 1
    possible_songs = Song.where("title LIKE '%#{input}%'")
    possible_songs.each do | song |
      songs_string += "#{i}. #{song.title} - #{song.artist}\n"
      i += 1
    end

    make_large_box(songs_string)
    new_input = gets.chomp!
    new_input.downcase!

    possible_songs[(new_input.to_i - 1)]
  end

  def remove_song_from_playlist(playlist)
    playlist_data = playlist.get_data
    playlist_song_array = []
    playlist.songs.each do | song |
      playlist_song_array << "#{song.title}"
    end

    songs_string = print_playlist_songs(playlist_song_array, playlist_data[:name])
    songs_string += "\nEnter name of song you want to remove: \n"
    make_large_box(songs_string)
    input = gets.chomp!
    input.downcase!

    song_to_delete = nil
    playlist.songs.each do | song |
      if (song.title).downcase! == input
        song_to_delete = song
      end
    end
    if song_to_delete != nil
      playlist.delete_song(song_to_delete)
    end
  end

  def optimize_playlist(playlist)
    playlist_data = playlist.get_data
    playlist_song_array = []
    playlist.songs.each do | song |
      playlist_song_array << "#{song.title}"
    end

    songs_string = print_playlist_songs(playlist_song_array, playlist_data[:name])
    optimize_prompt = "Optimize Playlist\nEnter a feature to optimize: \n-acousticness -danceability -energy\n-instrumentalness -liveness -speechiness\n-valence   -tempo\n"
    optimize_prompt += songs_string

    make_versatile_box(optimize_prompt)
    input = gets.chomp!
    input.downcase!
    #specific feature by col title
    #percent is a float less than 0
    #more is a boolean to determine if you want less or more
    playlist.optimize(feature, percent, more)
  end

  def print_playlist_songs(playlist_song_array, playlist_name)
    songs_string = ""
    songs_string += "#{playlist_name}\n"
    i = 0
    while i < (playlist_song_array.length)
      songs_string += "#{i+1}.#{playlist_song_array[i]}  \t\t"
      if ((i+1) % 2 ) == 0
        songs_string += "\n"
      end
      i += 1
    end
    songs_string += "\n---------------------------"
    songs_string
  end

  def print_table

    table = TTY::Table.new ["Songs In Playlist", "Playlist Data"], [["a1", "a2"], ["b1", "b2"]]
    #make_box(table)
    print table
    test_data = [
      {name: "acoustic", value: 5977, color: :bright_yellow},
      {name: "dancing", value: 3000, color: :bright_green},
      {name: "energetic", value: 2000, color: :bright_magenta},
      {name: "instrumental", value: 3000, color: :bright_cyan},
      {name: "live", value: 6500, color: :bright_black},
      {name: "happy", value: 2500, color: :bright_blue},
      {name: "fast", value: 2500, color: :bright_white}]
    #   {name: "happy", value: 1000, color: :green},
    #   {name: "melancholy", value: 7000, color: :red},
    #   {name: "slow", value: 3000, color: :bright_red},
    #   {name: "chill", value: 4000, color: :cyan}
    # ]
    pie_chart = TTY::Pie.new(data: test_data, radius: 7)
    print pie_chart
    #avg of a tag
    playlist_info = {"acoustic" => 0.77, "dancing" => 0.34, "energetic" => 0.67,
    "instrumental" => 0.13, "live" => 0.22, "lyrical" => 0.45,
    "fast" => 0.65, "happy" => 0.23, "melancholy" => 0.56, "slow" => 0.34,
    "chill" => 0.45}
    print_bargraph(playlist_info)
  end

  def print_bargraph(playlist_data, playlist_name)
    system "clear"
    bargraph_string = ""
    bargraph_string += "#{playlist_name}\n"
    i = 9
    while i >= 0
      bargraph_string += "#{i} |"
      playlist_data.each do | key, value |
        if key != "tempo"
          if (value * 10).round >= i
            (key.length).times do
              bargraph_string += "-"
            end
            #bargraph_string += "   -   "
          else
            # bargraph_string += "        "
            (key.length).times do
              bargraph_string += " "
            end
          end
          bargraph_string += " "
        end
      end
      if i == 0
        bargraph_string += " #{playlist_data["tempo"].round}"
      end
      bargraph_string += "\n"
      i -= 1
    end
    bargraph_string += "   acousticness danceability energy instrumentalness liveness speechiness valence tempo\n"
    make_large_box(bargraph_string)
  end

  #Artist menu and options
  # Artists section
  #   ---------------
  #   View all artist - returns a list of artist that begin with a certain letter, is passed a letter (cli displays, the user can choose alphabetical letter and the cli displays all artist that start with that letter)
  #   Find artist - is passed the name of an artist, returns the artist. (cli displays artist)
  def artists
    make_box("Artists\n1. View All Artists\n2. Find Artist\n3. Back")

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view all artists"
        view_all_artists
      when "2", "find artist"
        find_artist
    end
  end

  def view_all_artists
    make_box("view all artist")
  end

  def find_artist
    make_box("find artist")
  end

  #songs section

  def songs
    make_box("Songs\n1. View Top Songs By Tag\n2. Find Song\n3. Back\n")

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

    make_box("View Top Songs By Tag\nEnter tag to view top 10 songs: \n- acoustic  - dancing  - energetic\n- instrumental  - live   - lyrical\n- fast   - happy   - melancholy\n- slow    - chill\n")

    input = gets.chomp!
    input.downcase!

    tags.each do | tag |
      if input == tag
        top_songs_string = "Top Songs for #{tag}: \n"
        # view_top_songs(tag).each do | song |
        #   top_songs_string << "#{song}\n"
        # end
        make_box(top_songs_string)
      end
    end
  end

  def find_song
    make_box("Searching For Song")
  end

  def main_menu
    make_box("Welcome! #{self.username}\n1. Playlists\n2. Songs\n3. Exit")
  end

  def black_eyed_peas
    system "clear"
    puts "---------------------------------"
    puts "|    Black-Eyed-Peas Fanclub    |"
    puts "| ----------------------------  |"
    puts "     Welcome! #{self.username}   "
    puts "|                               |"
    puts "| 1. Black-Eyed-Peas            |"
    puts "| 2. Black-Eyed-Peas            |"
    puts "| 3. Black-Eyed-Peas            |"
    puts "| 4. Black-Eyed-Peas            |"
    puts "|                               |"
    puts "---------------------------------"
  end

end
