require 'rails_helper'

RSpec.describe Circle, type: :model do
  subject { build(:circle) } # Usa FactoryBot

  # Associations
  it { is_expected.to belong_to(:square) }

  # Validations
  it { is_expected.to validate_presence_of(:center_x) }
  it { is_expected.to validate_presence_of(:center_y) }
  it { is_expected.to validate_presence_of(:diameter) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'without required attributes' do
    it 'is not valid without center_x' do
      subject.center_x = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:center_x]).to include("can't be blank")
    end

    it 'is not valid without center_y' do
      subject.center_y = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:center_y]).to include("can't be blank")
    end

    it 'is not valid without diameter' do
      subject.diameter = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:diameter]).to include("can't be blank")
    end
  end

  context 'when circles intersect in the same square' do
    let(:square) { create(:square) }
    before do
      create(:circle, square: square, center_x: 5.0, center_y: 5.0, diameter: 5.0)
    end

    it 'is not valid if it intersects another circle' do
      overlapping_circle = build(:circle, square: square, center_x: 5.0, center_y: 5.0, diameter: 5.0)
      expect(overlapping_circle).not_to be_valid
      expect(overlapping_circle.errors[:base]).to include(/intersect/i)
    end
  end
end
