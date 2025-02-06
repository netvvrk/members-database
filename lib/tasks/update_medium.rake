require 'csv' 

namespace :update_medium do
  desc "update medium based on material"
  task from_material: :environment do
    mapping_file = Rails.root.join('lib', 'assets', 'material-medium-mapping.csv')
    mapping = CSV.open(mapping_file).each.to_a
    mapping.shift
    mapping.each { | item | Artwork.where(material: item[0]).update_all(medium: item[1]) }
    
  end
end
