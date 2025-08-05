class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :radius, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :radius, numericality: { greater_than: 0 }
  validate :fits_within_frame
  validate :no_touching_circles

  private
  def ready_for_geometric_validation?
    frame.present? && center_x.present? && center_y.present? && radius.present?
  end

  def fits_within_frame
    return unless ready_for_geometric_validation?

    if center_x - radius / 2 < frame.center_x - frame.width / 2 ||
        center_x + radius / 2 > frame.center_x + frame.width / 2 ||
        center_y - radius / 2 < frame.center_y - frame.height / 2 ||
        center_y + radius / 2 > frame.center_y + frame.height / 2
      errors.add(:base, "Circle must fit completely within the frame.")
    end
  end

  def no_touching_circles
    return unless ready_for_geometric_validation?

    frame.circles.where.not(id: self.id).each do |other_circle|
      if self.center_x - radius / 2 < other_circle.center_x + other_circle.radius / 2 &&
        self.center_x + radius / 2 > other_circle.center_x - other_circle.radius / 2 &&
        self.center_y - radius / 2 < other_circle.center_y + other_circle.radius / 2 &&
        self.center_y + radius / 2 > other_circle.center_y - other_circle.radius / 2
        errors.add(:base, "Circles cannot touch or intersect.")
      end
    end
  end
end
