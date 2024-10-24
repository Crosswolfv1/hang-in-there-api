class Api::V1::PostersController < ApplicationController

  def index
    posters = Poster.all
    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)
  end

  def update
    poster = Poster.update(params[:id], posters_params)
  render json: PosterSerializer.format_poster(poster)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  def create
    poster =  Poster.create(posters_params)
     render json: PosterSerializer.format_poster(poster)
    #redirect "/posters/#{poster[:data][:id]}"
  end

  private

  def posters_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url )
  end
end