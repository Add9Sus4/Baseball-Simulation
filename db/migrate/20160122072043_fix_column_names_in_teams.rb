class FixColumnNamesInTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.rename :catcher_id, :catcher
      t.rename :designated_hitter_id, :designated_hitter
      t.rename :first_base_id, :first_base
      t.rename :second_base_id, :second_base
      t.rename :third_base_id, :third_base
      t.rename :shortstop_id, :shortstop
      t.rename :left_field_id, :left_field
      t.rename :center_field_id, :center_field
      t.rename :right_field_id, :right_field
      t.rename :bench1_id, :bench1
      t.rename :bench2_id, :bench2
      t.rename :bench3_id, :bench3
      t.rename :bench4_id, :bench4
    end
  end
end
