class CaptionsOptional < ActiveRecord::Migration[7.1]
  def change
    change_column_default :images, :caption, nil
    change_column_null :images, :caption, true
  end
end
