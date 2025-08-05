class UpdateCirclesReferenceToFrames < ActiveRecord::Migration[6.0]
  def up
    add_column :circles, :frame_id, :bigint
    add_foreign_key :circles, :frames

    if foreign_key_exists?(:circles, :squares)
      remove_foreign_key :circles, :squares
    end

    remove_column :circles, :square_id
  end

  def down
    add_column :circles, :square_id, :bigint
    add_foreign_key :circles, :squares

    if foreign_key_exists?(:circles, :frames)
      remove_foreign_key :circles, :frames
    end

    remove_column :circles, :frame_id
  end
end
