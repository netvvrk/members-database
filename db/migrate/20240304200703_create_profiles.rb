class CreateProfiles < ActiveRecord::Migration[7.1]
  def up
    create_table :profiles do |t|
      t.belongs_to :user
      t.string :bio
      t.string :website
      t.string :social_1
      t.string :social_2
      t.string :disciplines

      t.timestamps
    end

    User.all.each { |u| u.profile = Profile.create }
  end

  def down 
    drop_table :profiles
  end

end
