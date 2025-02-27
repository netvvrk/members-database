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

    artworks_for_grouping = Artwork.is_active.is_visible.with_images.all

    @artworks = Artwork.is_visible.with_images.all
    @artworks = if @search_term.present?
      # with_pg_search_rank is to avoid sql error (see commit message)
      @artworks.search(@search_term).with_pg_search_rank
      # .reorder("") is needed to get rid of rank column for grouping
      artworks_for_grouping = artworks_for_grouping.search(@search_term).reorder("") 
    else
      @artworks.order(:non_search_rank)
    end
    if @max_price.present?
      @artworks = @artworks.has_max_price(@max_price)
      artworks_for_grouping = artworks_for_grouping.has_max_price(@max_price)
    end
    if @min_price.present?
      @artworks = @artworks.has_min_price(@min_price)
      artworks_for_grouping = artworks_for_grouping.has_min_price(@min_price)
    end
    if @location.present?
      @artworks = @artworks.has_location(@location)
      artworks_for_grouping = artworks_for_grouping.has_location(@location)
    end
    if @medium.present?
      @artworks = @artworks.has_medium(@medium)
      artworks_for_grouping = artworks_for_grouping.has_medium(@medium)
    end

    @artworks = @artworks.page(@page)

    location_options = artworks_for_grouping.group(:location).order(count: :desc).count

    @location_options = location_options.each_with_index.reduce([]) do |acc, (item, i)|
      show_by_default = acc.size < 5
      acc.push(OpenStruct.new(
        id: item.first,
        name: "#{item.first} (#{item.last})",
        count: item.last,
        show_by_default: show_by_default
      ))
    end

    medium_options = artworks_for_grouping.group(:medium).order(count: :desc).count

    @medium_options = medium_options.each_with_index.reduce([]) do |acc, (item, i)|
      acc.push(OpenStruct.new(
        id: item.first,
        name: "#{item.first} (#{item.last})",
        count: item.last
      ))
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
