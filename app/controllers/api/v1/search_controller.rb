# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  def index
    @songs = Song.where('title LIKE $1', params[:query])
    @albums = Album.where('title LIKE $1', params[:query])
    @artists = Artist.where('name LIKE $1', params[:query])
  end
end
