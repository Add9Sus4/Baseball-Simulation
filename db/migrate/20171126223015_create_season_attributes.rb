class CreateSeasonAttributes < ActiveRecord::Migration
  def change
    create_table :season_attributes do |t|

      t.timestamps null: false
    end
  end
end
