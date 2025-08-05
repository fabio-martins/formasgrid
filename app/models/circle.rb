class Circle < ApplicationRecord
  belongs_to :square

  validates :center_x, :center_y, :diameter, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :diameter, numericality: { greater_than: 0 }
  validate :fits_within_square
  validate :no_touching_circles

  private
  def ready_for_geometric_validation?
    square.present? && center_x.present? && center_y.present? && diameter.present?
  end

  def fits_within_square
    return unless ready_for_geometric_validation?

    if center_x - diameter / 2 < square.center_x - square.width / 2 ||
        center_x + diameter / 2 > square.center_x + square.width / 2 ||
        center_y - diameter / 2 < square.center_y - square.height / 2 ||
        center_y + diameter / 2 > square.center_y + square.height / 2
      errors.add(:base, "Circle must fit completely within the square.")
    end
  end

  def no_touching_circles
    return unless ready_for_geometric_validation?

    square.circles.where.not(id: self.id).each do |other_circle|
      if self.center_x - diameter / 2 < other_circle.center_x + other_circle.diameter / 2 &&
        self.center_x + diameter / 2 > other_circle.center_x - other_circle.diameter / 2 &&
        self.center_y - diameter / 2 < other_circle.center_y + other_circle.diameter / 2 &&
        self.center_y + diameter / 2 > other_circle.center_y - other_circle.diameter / 2
        errors.add(:base, "Circles cannot touch or intersect.")
      end
    end
  end
end
