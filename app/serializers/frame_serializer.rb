class FrameSerializer < ActiveModel::Serializer
  attributes :id, :center_x, :center_y, :width, :height,
             :total_circles, :highest_circle, :lowest_circle,
             :leftmost_circle, :rightmost_circle

  def center_x
    object.center_x.to_f
  end

  def center_y
    object.center_y.to_f
  end

  def width
    object.width.to_f
  end

  def height
    object.height.to_f
  end

  def total_circles
    object.circles.count
  end

  def highest_circle
    serialize_circle(object.circles.order(center_y: :asc).last)
  end

  def lowest_circle
    serialize_circle(object.circles.order(center_y: :asc).first)
  end

  def leftmost_circle
    serialize_circle(object.circles.order(center_x: :asc).first)
  end

  def rightmost_circle
    serialize_circle(object.circles.order(center_x: :desc).first)
  end

  private

  def serialize_circle(circle)
    return nil unless circle
    {
      id:        circle.id,
      center_x:  circle.center_x.to_f,
      center_y:  circle.center_y.to_f,
      diameter:  circle.diameter.to_f
    }
  end
end
