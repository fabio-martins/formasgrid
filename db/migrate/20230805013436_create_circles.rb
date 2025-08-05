class CreateCircles < ActiveRecord::Migration[6.0]
  def change
    create_table :circles do |t|
      t.references :square, null: false, foreign_key: true
      t.decimal :center_x, precision: 10, scale: 2
      t.decimal :center_y, precision: 10, scale: 2
      t.decimal :diameter, precision: 10, scale: 2

      t.timestamps
    end
  end
end