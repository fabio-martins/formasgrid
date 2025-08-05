class CircleSerializer < ActiveModel::Serializer
  attributes :id, :center_x, :center_y, :diameter
end
