class ChangeProfileBioType < ActiveRecord::Migration[7.1]
  def change
    change_table :profiles do |t|
      t.change :bio, :text
    end
  end
end
