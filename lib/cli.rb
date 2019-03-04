class CLI
  attr_accessor :username

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
        when "2", "artists"
          artists
        when "3", "songs"
          songs
        when "4", "exit"
          exit_flag = true
      end
    end
  end

  def welcome_screen
    system "clear"
    print_title
    puts "|                               |"
    puts "|    " + Rainbow("Please enter your name:").silver + "    |"
    puts "|                               |"
    puts "|                               |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"

    self.username = gets.chomp!
    if self.username.downcase == "lane"
      black_eyed_peas
    end
  end

  # Playlist menu and options

  def playlists
    system "clear"
    print_title
    print_option_title("Playlists")
    print_options(["1. Generate Playlist", "2. View All Playlists", "3. Find Playlist", "4. Back"])

    input = gets.chomp!
    input.downcase!
    case(input)
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
    system "clear"
    print_title
    print_option_title("Generate Playlist")
    print_options(["Enter name for playlist:", "Enter number of songs:"])
    playlist_name = gets.chomp!

    array_of_tags = tag_selection
    #new_playlist = generate_new_playlist
    input = gets.chomp!
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
      system "clear"
      print_title
      print_option_title("Generate Playlist")
      print_options(["Enter tags for playlist seperated by a space:", "Type 'submit' when finished.", "#{tags["acoustic"]}  #{tags["dancing"]}  #{tags["energetic"]}",
        "#{tags["instrumental"]}  #{tags["live"]}  #{tags["lyrical"]}", "#{tags["fast"]}  #{tags["happy"]}  #{tags["melancholy"]}", "#{tags["slow"]}  #{tags["chill"]}"])

      input = gets.chomp!
      input.downcase!
      input_array = input.split
      input_array.each do | word |
        if word == "submit"
          tags.each do | key, value |
            if value[0] == "☑"
              array_of_tags << key
            end
          end
          puts "|-------------------------------|"
          puts array_of_tags.uniq
          puts "|-------------------------------|"
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

  def view_all_playlists
    print_title
    print_option_title("All Playlsit")
    print_options(["Enter name of playlist: "])

    #get all playlist
    playlists = ["playlist 1", "playlist 2", "playlist 3"]
    playlists.each do | playlist |
      puts "| " + Rainbow("#{playlist}").silver + "      |"
    end
    input = gets.chomp!
  end

  def find_playlist
    print_title
    print_option_title("Find Playlist")
    print_options(["Enter name of playlist: "])

    input = gets.chomp!
    input.downcase!
    #search for playlist
    playlist = ["test song1", "test_song2"]
    display_playlist(playlist)
    input = gets.chomp!
  end

  def display_playlist(playlist)
    playlist_name = "Test Playlist"
    print_title
    puts "| " + Rainbow("#{playlist_name}").silver.underline + " |"
    playlist.each do | song |
      puts "| " + Rainbow("#{song}").silver + "    |"
    end
    puts "|-------------------------------|"
  end

  #Artist menu and options

  def artists
    print_title
    print_option_title("Artists")
    print_options(["1. View All Artists", "2. Find Artist", "3. Back"])

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view all artists"
        view_all_artists
      when "2", "find artist"
        find_artist
      # when "3", "find playlist"
      #   find_playlist
      # when "4", "back"
      #   exit_flag = true
    end
  end

  def view_all_artists
    system "clear"
    puts "|-------------------------------|"
    puts "|    Displaying All Artists     |"
    puts "|-------------------------------|"
  end

  def find_artist
    system "clear"
    puts "|-------------------------------|"
    puts "|      Searching For Artist     |"
    puts "|-------------------------------|"
  end

  def songs
    print_title
    print_option_title("Songs")
    print_options(["1. View All Songs", "2. Find Song", "3. Back"])

    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view all songs"
        view_all_songs
      when "2", "find song"
        find_song
    end
  end

  def view_all_songs
    system "clear"
    puts "|-------------------------------|"
    puts "|     Displaying All Songs      |"
    puts "|-------------------------------|"
  end

  def find_song
    system "clear"
    puts "|-------------------------------|"
    puts "|       Searching For Song      |"
    puts "|-------------------------------|"
  end

  def main_menu
    print_title
    print_option_title("Welcome! #{self.username}")
    print_options(["1. Playlists", "2. Artists", "3. Songs", "4. Exit"])
  end

  def print_option_title(option_title)
    puts "|\t" + Rainbow("#{option_title}").silver.underline
  end

  def print_options(options)
    options.each do | line |
      puts "|\t" + Rainbow("#{line}").silver
    end
    puts "|                               |"
    puts "---------------------------------"
  end

  def print_title
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Welcome to").green + "            |"
    puts "| ----------------------------  |"
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
