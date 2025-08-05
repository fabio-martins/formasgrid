class RenameSquaresToFrames < ActiveRecord::Migration[6.0]
  def change
    rename_table :squares, :frames
  end
end
