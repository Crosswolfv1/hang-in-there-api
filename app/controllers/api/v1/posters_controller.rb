class Api::V1::PostersController < ApplicationController

  def index
    posters = Poster.all
    posters = sort_posters(posters)
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

  private

  def posters_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url )
  end

  def sort_posters(scope)
    order = params[:sort]
    if order.present? && order.presence_in(%w[asc desc])
        scope.order(created_at: order)
    else
      scope.order(created_at: :desc)
    end
  end
end