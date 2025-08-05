class CircleSerializer < ActiveModel::Serializer
  attributes :id, :center_x, :center_y, :radius

  def center_x
    object.center_x.to_f
  end

  def center_y
    object.center_y.to_f
  end

  def radius
    object.radius.to_f
  end
end
