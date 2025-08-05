class Square < ApplicationRecord
  has_many :circles, dependent: :destroy

  validates :center_x, :center_y, :width, :height, numericality: { greater_than_or_equal_to: 0 }
  validates :width, :height, numericality: { greater_than: 0 }
  validate :no_touching_squares

  private

  def no_touching_squares
    Square.all.each do |other_square|
      next if self == other_square

      if (self.center_x - self.width / 2 < other_square.center_x + other_square.width / 2 &&
          self.center_x + self.width / 2 > other_square.center_x - other_square.width / 2 &&
          self.center_y - self.height / 2 < other_square.center_y + other_square.height / 2 &&
          self.center_y + self.height / 2 > other_square.center_y - other_square.height / 2)
        errors.add(:base, "Squares cannot touch or intersect.")
      end
    end
  end
end