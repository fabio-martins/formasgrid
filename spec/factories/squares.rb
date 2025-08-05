# spec/factories/squares.rb
FactoryBot.define do
  factory :square do
    center_x { 5.0 }
    center_y { 5.0 }
    width    { 10.0 }
    height   { 10.0 }
  end
end
