class RenameDiameterToRadiusInCircles < ActiveRecord::Migration[8.0]
  def change
    rename_column :circles, :diameter, :radius
  end
end
