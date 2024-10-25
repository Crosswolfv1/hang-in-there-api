class Api::V1::PostersController < ApplicationController

  def index
    posters = Poster.all
    posters = sort_posters(posters)
    posters = filter_posters(posters)
      options = meta: {
        count: posters.length
      }
  
    render json: PosterSerializer.new(posters, options)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.new(poster)
  end

  def update
    poster = Poster.update(params[:id], posters_params)
  render json: PosterSerializer.new(poster)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  def create
    poster =  Poster.create(posters_params)
     render json: PosterSerializer.new(poster)
    #redirect "/posters/#{poster[:data][:id]}"
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

  def filter_posters(scope)
    name_filter(scope).then {max_filter(_1)}.then {min_filter(_1)}
  end

  def name_filter(scope)
    filter = params[:name]
    if filter.present? #&& filter.includes?(:name)
      scope.where("LOWER(name) LIKE ?", "%#{filter}%")
    else
      scope
    end
  end

  def max_filter(scope)
    filter = params[:max_price]
    if filter.present?
      scope.where("price < ?", "#{filter}")
    else
      scope
    end
  end

  def min_filter(scope)
    filter = params[:min_price]
    if filter.present?
      scope.where("price > ?", "#{filter}")
    else
      scope
    end
  end
end