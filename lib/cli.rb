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
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Welcome to").green + "            |"
    puts "| ----------------------------  |"
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
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("Playlists").silver.underline + "                     |"
    puts "| " + Rainbow("1. Generate Playlist").silver + "          |"
    puts "| " + Rainbow("2. View All Playlists").silver + "         |"
    puts "| " + Rainbow("3. Find Playlist").silver + "              |"
    puts "| " + Rainbow("4. Back").silver + "                       |"
    puts "|                               |"
    puts "|-------------------------------|"
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
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("Generate Playlist").silver.underline + "             |"
    puts "| " + Rainbow("Enter name for playlist:").silver + "      |"
    puts "|                               |"
    puts "|                               |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"
    playlist_name = gets.chomp!
    # system "clear"
    # puts "|-------------------------------|"
    # puts "|         " + Rainbow("Marinading on it").green + "      |"
    # puts "| ----------------------------  |"
    # puts "| " + Rainbow("Generate Playlist").silver.underline + "             |"
    # puts "| " + Rainbow("Enter tags for playlist seperated by a space:").silver + "     |"
    # puts "| " + Rainbow("Type 'submit' when finished.").silver + "     |"
    # puts "|                               |"
    # puts "|     ☐  ☑                             |"
    # puts "|                               |"
    # puts "|-------------------------------|"

    array_of_tags = tag_selection
    #new_playlist = generate_new_playlist
    input = gets.chomp!
  end

  def tag_selection
    input = ""
    input_done = false

    tags = {"acoustic" => "☐ acoustic", "dancing" => "☐ dancing", "energetic" => "☐ energetic",
    "instrumental" => "☐ instrumental", "live" => "☐ live", "lyrical" => "☐ lyrical",
    "fast" => "☐ fast", "happy" => "☐ happy", "melancholy" => "☐ melancholy"}

    array_of_tags = []

    while (!input_done)
      system "clear"
      puts "|-------------------------------|"
      puts "|         " + Rainbow("Marinading on it").green + "      |"
      puts "| ----------------------------  |"
      puts "| " + Rainbow("Generate Playlist").silver.underline + "             |"
      puts "| " + Rainbow("Enter tags for playlist seperated by a space:").silver + "     |"
      puts "| " + Rainbow("Type 'submit' when finished.").silver + "     |"
      puts "|  #{tags["acoustic"]}  #{tags["dancing"]}  #{tags["energetic"]}       |"
      puts "|  #{tags["instrumental"]}  #{tags["live"]}  #{tags["lyrical"]}       |"
      puts "|  #{tags["fast"]}  #{tags["happy"]}  #{tags["melancholy"]}       |"
      puts "|                               |"
      puts "|-------------------------------|"
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
        end
      end
    end
    array_of_tags
  end

  def view_all_playlists
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("All Playlsit").silver.underline + "                    |"
    puts "| " + Rainbow("Enter name of playlist: ").silver + "        |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"
    #get all playlist
    playlists = ["playlist 1", "playlist 2", "playlist 3"]
    playlists.each do | playlist |
      puts "| " + Rainbow("#{playlist}").silver + "      |"
    end
    input = gets.chomp!
  end

  def find_playlist
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("Find Playlsit").silver.underline + "                   |"
    puts "| " + Rainbow("Enter name of playlist: ").silver + "        |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"
    input = gets.chomp!
    input.downcase!
    #search for playlist
    playlist = ["test song1", "test_song2"]
    display_playlist(playlist)
    input = gets.chomp!
  end

  def display_playlist(playlist)
    playlist_name = "Test Playlist"
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("#{playlist_name}").silver.underline + " |"
    playlist.each do | song |
      puts "| " + Rainbow("#{song}").silver + "    |"
    end
    puts "|-------------------------------|"
  end

  #Artist menu and options

  def artists
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("Artists").silver.underline + "                       |"
    puts "| " + Rainbow("1. View All Artists").silver + "           |"
    puts "| " + Rainbow("2. Find Artist").silver + "                |"
    #puts "| 3. Find Playlist              |"
    puts "| " + Rainbow("3. Back").silver + "                       |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"
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
    system "clear"
    puts "|-------------------------------|"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "| " + Rainbow("Songs").silver.underline + "                         |"
    puts "| " + Rainbow("1. View All Songs").silver + "             |"
    puts "| " + Rainbow("2. Find Song").silver + "                  |"
    #puts "| 3. Find Playlist              |"
    puts "| " + Rainbow("3. Back").silver + "                       |"
    puts "|                               |"
    puts "|                               |"
    puts "|-------------------------------|"
    input = gets.chomp!
    input.downcase!
    case(input)
      when "1", "view all songs"
        view_all_songs
      when "2", "find song"
        find_song
      # when "3", "find playlist"
      #   find_playlist
      # when "4", "back"
      #   exit_flag = true
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
    system "clear"
    puts "---------------------------------"
    puts "|         " + Rainbow("Marinading on it").green + "      |"
    puts "| ----------------------------  |"
    puts "|     " + Rainbow("Welcome! #{self.username}").silver.underline + "  "
    puts "|                               |"
    puts "| " + Rainbow("1. Playlists").silver + "                  |"
    puts "| " + Rainbow("2. Artists").silver + "                    |"
    puts "| " + Rainbow("3. Songs").silver + "                      |"
    puts "| " + Rainbow("4. Exit").silver + "                       |"
    puts "|                               |"
    puts "---------------------------------"
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
