require "ostruct"

class MainController < ApplicationController
  # GET /
  def index
    @page = params[:page]&.to_i || 0
    @search_term = params[:search]
    @min_price = params[:min_price] if params[:min_price].to_i.to_s == params[:min_price]
    @max_price = params[:max_price] if params[:max_price].to_i.to_s == params[:max_price]
    @location = params[:location]
    @medium = params[:medium]
    @has_filters = @min_price.present? || @max_price.present? ||
      @location.present? || @medium.present?

    location_options = Artwork.is_active.is_visible.with_images.all.group(:location).order(count: :desc).count

    @location_options = location_options.each_with_index.reduce([]) do |acc, (item, i)|
      show_by_default = acc.size < 5
      acc.push(OpenStruct.new(
        id: item.first,
        name: "#{item.first} (#{item.last})",
        count: item.last,
        show_by_default: show_by_default
      ))
    end

    medium_options = Artwork.is_visible.with_images.all.group(:medium).order(count: :desc).count

    @medium_options = medium_options.each_with_index.reduce([]) do |acc, (item, i)|
      acc.push(OpenStruct.new(
        id: item.first,
        name: "#{item.first} (#{item.last})",
        count: item.last
      ))
    end

    @artworks = Artwork.is_visible.with_images.all.page(@page)
    @artworks = if @search_term.present?
      # with_pg_search_rank is to avoid sql error (see commit message)
      @artworks.search(@search_term).with_pg_search_rank
    else
      @artworks.order(:non_search_rank)
    end
    if @max_price.present?
      @artworks = @artworks.where("price < ? ", @max_price)
    end
    if @min_price.present?
      @artworks = @artworks.where("price > ? ", @min_price)
    end
    if @location.present?
      @artworks = @artworks.where("location in (?) ", @location)
    end
    if @medium.present?
      @artworks = @artworks.where("medium in (?) ", @medium)
    end
  end

  # GET artwork/1
  def show
    @artwork = Artwork.find(params[:id])
    if !@artwork.visible && !belongs_to_user
      redirect_to root_url
    end
  end

  private

  def belongs_to_user
    current_user&.id == @artwork.user.id
  end
end
