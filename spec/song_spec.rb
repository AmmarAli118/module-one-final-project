# spec/song_spec.rb
require 'spec_helper'

describe Song do
  let(:test_song) {Song.create(title: "this is a test")}

  describe "#add_song_to_playlist" do
    it "adds itself to a given playlist" do
      test_song.add_to_playlist(Playlist.last)
      expect(Playlist.last.songs).to include(test_song)
    end
  end

  describe "#short_title" do


    it "truncates a title longer than 30 characters" do
      long_title = "This song title is entirely too long and should be much shorter ok thanks bye"
      song = Song.new(title: long_title)
      expect(song.short_title.length).to eq(30)
    end

    it "does not affect the length of short titles" do
      song = Song.new(title: "Blissful Misery")
      expect(song.short_title.length).to eq(song.title.length)
    end
  end
end
