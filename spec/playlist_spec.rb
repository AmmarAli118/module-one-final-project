# spec/playlist_spec.rb
require 'spec_helper'



describe Playlist do
  let(:playlist) {Playlist.last}
  let(:song) {Song.last}
  
  before do
    playlist.add_song(song)
  end

  describe "#valid_index" do
    it "returns false if index is outside of the size of the playlist" do
      expect(playlist.valid_index?(1000)).to eq(false)
      expect(playlist.valid_index?(0)).to eq(false)
    end
    it "returns true if index is inside playlist length" do
      expect(playlist.valid_index?(1)).to eq(true)
    end
  end
end
