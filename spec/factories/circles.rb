FactoryBot.define do
  factory :circle do
    square
    center_x { 5.0 }
    center_y { 5.0 }
    diameter { 5.0 }
  end
end
