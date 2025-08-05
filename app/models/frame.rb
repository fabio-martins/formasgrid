class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy

  validates :center_x, :center_y, :width, :height, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :width, :height, numericality: { greater_than: 0 }
  validate :no_touching_frames

  private

  def no_touching_frames
    Frame.all.each do |other_frame|
      next if self == other_frame

      if self.center_x - self.width / 2 < other_frame.center_x + other_frame.width / 2 &&
         self.center_x + self.width / 2 > other_frame.center_x - other_frame.width / 2 &&
         self.center_y - self.height / 2 < other_frame.center_y + other_frame.height / 2 &&
         self.center_y + self.height / 2 > other_frame.center_y - other_frame.height / 2
        errors.add(:base, "Frames cannot touch or intersect.")
      end
    end
  end
end
