class CreateSquares < ActiveRecord::Migration[6.0]
  def change
    create_table :squares do |t|
      t.decimal :center_x, precision: 10, scale: 2
      t.decimal :center_y, precision: 10, scale: 2
      t.decimal :width, precision: 10, scale: 2
      t.decimal :height, precision: 10, scale: 2

      t.timestamps
    end
  end
end