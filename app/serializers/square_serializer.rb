class SquareSerializer < ActiveModel::Serializer
  attributes :id, :center_x, :center_y, :width, :height, :total_circles, :highest_circle, :lowest_circle, :leftmost_circle, :rightmost_circle

  def total_circles
    object.circles.count
  end

  def highest_circle
    object.circles.order(center_y: :asc).last
  end

  def lowest_circle
    object.circles.order(center_y: :asc).first
  end

  def leftmost_circle
    object.circles.order(center_x: :asc).first
  end

  def rightmost_circle
    object.circles.order(center_x: :desc).first
  end
end
