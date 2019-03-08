# SpOptimizer

This is a Command Line Interface for

## Features
* Create and edit playlists
* View the audio features of your songs, such as their energy level and danceability.
* Generate playlists based on user-specified criteria like "energetic/chill", "happy/melancholy"
* Optimize the average features of your playlist automatically.

## Installation
On the command line, run bundle to install the required gems:

    bundle install

Initiate the database:

    rake db:migrate
    rake db:seed
Run the application:

    ruby bin/run.rb

## Using SpOptimizer

* Follow the onscreen instructions to browse your songs and playlists.
* Press the enter key to go back

**This application was made possible with these awesome gems:**

[RSpotify](https://github.com/guilhermesad/rspotify)

[TTY](https://github.com/piotrmurach/tty)
