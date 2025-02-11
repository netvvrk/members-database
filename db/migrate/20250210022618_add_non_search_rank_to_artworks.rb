class AddNonSearchRankToArtworks < ActiveRecord::Migration[7.2]
  def change
    add_column :artworks, :non_search_rank, :decimal
  end
end
