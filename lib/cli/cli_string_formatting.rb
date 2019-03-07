#Methods for formatting strings to work well with tty on cli
#----------------------------
#Graphs and table makers
#----------------------------
module CliStringFormatting
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
  end

  def get_bargraph(data, name)
    system "clear"
    bargraph_string = ""
    bargraph_string += "#{name}\n"
    i = 9
    while i >= 0
      bargraph_string += "#{i} |"
      data.each do | key, value |
        if key != "tempo" && key != "speechiness"
          if (value * 10).round >= i
            (key.length).times do
              bargraph_string += "-"
            end
          else
            (key.length).times do
              bargraph_string += " "
            end
          end
          bargraph_string += " "
        end
      end
      if i == 0
        bargraph_string += " #{data["tempo"].round}"
      end
      bargraph_string += "\n"
      i -= 1
    end
    bargraph_string += "   acousticness danceability energy instrumentalness liveness valence tempo\n"
    bargraph_string += "---"
    data.each do | key, value |
      if key != "tempo" && key != "speechiness"
        ((key.length - 4) / 2).times do
          bargraph_string += "-"
        end
        bargraph_string += "#{'%.3f' % value}"
        ((key.length - 4) / 2).times do
          bargraph_string += "-"
        end
      elsif key == "tempo"
        (key.length).times do
          bargraph_string += "-"
        end
      end
    end
    bargraph_string
  end
  #-------------------------------
  #Methods for formating output
  #-------------------------------
  def columnize_song_name_array(song_name_array, numbered_items = true, columns = 2, numbering_start = 0)
    formatted_string = ""
    longest_song_name_length = get_length_longest_name_in_array(song_name_array) + 5
    i = 0
    while i < (song_name_array.length)
      if numbered_items
        list_item = "#{numbering_start+1}.#{song_name_array[i]}"
      else
        list_item = "#{song_name_array[i]}"
      end
      formatted_string += list_item
      (longest_song_name_length - list_item.length).times do
        formatted_string += " "
      end
      if ((i+1) % columns ) == 0
        formatted_string += "\n"
      end
      i += 1
      numbering_start += 1
    end
    formatted_string += "\n-----------------------------------------"
    formatted_string
  end
  #helper method for getting length of longest name in array
  def get_length_longest_name_in_array(song_name_array)
    longest_song_name_length = 0
    song_name_array.each do | song_name |
      if song_name.length > longest_song_name_length
        longest_song_name_length = song_name.length
      end
    end
    longest_song_name_length
  end

  def get_page_string(pages, page_number)
    #display playlist
    number_start_for_columnizer = page_number*20
    page_string = ""
    page_string += columnize_song_name_array(pages[page_number], true, 2, number_start_for_columnizer)
    page_string += "\nPage: "
    i = 0
    (pages.length).times do
      if i == page_number
        page_string += "|*#{page_number + 1}*|"
        i += 1
      else
        page_string += "| #{i + 1} |"
        i += 1
      end
    end
    page_string += "\n-----------------------------------------"
    page_string
  end

  #Method for splitting song arrays into pages
  def split_song_array_into_pages(song_name_array, lines_per_page = 10, columns = 2)
    #split into chunks
    pages =[]
    items_per_page = 0
    new_page = []
    song_name_array.each do | song_name |
      if items_per_page < (lines_per_page * columns)
        new_page << song_name
        items_per_page += 1
      else
        pages << new_page
        new_page = []
        new_page << song_name
        items_per_page = 1
      end
    end
    pages << new_page

    pages
  end

  def get_all_playlist_names_array
    all_playlist_names_array = []
    Playlist.all.each do | playlist |
      all_playlist_names_array << playlist.name
    end
    all_playlist_names_array
  end


  # --------------------------------
  #methods for making display boxes
  #--------------------------------
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
    longest_line += 3

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
end
