class Circle < ApplicationRecord
  belongs_to :square

  validates :center_x, :center_y, :diameter, numericality: { greater_than_or_equal_to: 0 }
  validates :diameter, numericality: { greater_than: 0 }
  validate :fits_within_square
  validate :no_touching_circles

  private

  def fits_within_square
    square = Square.find(square_id)
    if (center_x - diameter / 2 < square.center_x - square.width / 2 ||
        center_x + diameter / 2 > square.center_x + square.width / 2 ||
        center_y - diameter / 2 < square.center_y - square.height / 2 ||
        center_y + diameter / 2 > square.center_y + square.height / 2)
      errors.add(:base, "Circle must fit completely within the square.")
    end
  end

  def no_touching_circles
    square.circles.each do |other_circle|
      next if self == other_circle

      if (self.center_x - diameter / 2 < other_circle.center_x + other_circle.diameter / 2 &&
          self.center_x + diameter / 2 > other_circle.center_x - other_circle.diameter / 2 &&
          self.center_y - diameter / 2 < other_circle.center_y + other_circle.diameter / 2 &&
          self.center_y + diameter / 2 > other_circle.center_y - other_circle.diameter / 2)
        errors.add(:base, "Circles cannot touch or intersect.")
      end
    end
  end
end