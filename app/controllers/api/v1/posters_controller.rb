class Api::V1::PostersController < ApplicationController

  def index
    render json: Poster.all
  end

  def show
    poster = Poster.find(params[:id])
    render json: poster
  end

  def update
  render json: Poster.update(params[:id], posters_params)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  private

  def posters_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url )
  end
end