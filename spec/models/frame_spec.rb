require 'rails_helper'

RSpec.describe Frame, type: :model do
  subject { build(:frame) }

  # Associations
  it { is_expected.to have_many(:circles).dependent(:destroy) }

  # Validations
  it { is_expected.to validate_presence_of(:center_x) }
  it { is_expected.to validate_presence_of(:center_y) }
  it { is_expected.to validate_presence_of(:width) }
  it { is_expected.to validate_presence_of(:height) }

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

    it 'is not valid without width' do
      subject.width = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:width]).to include("can't be blank")
    end

    it 'is not valid without height' do
      subject.height = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:height]).to include("can't be blank")
    end
  end

  context 'when intersecting with another frame' do
    before do
      create(:frame, center_x: 5.0, center_y: 5.0, width: 10.0, height: 10.0)
    end

    it 'is not valid if it intersects with an existing frame' do
      intersecting_frame = build(:frame, center_x: 10.0, center_y: 10.0, width: 10.0, height: 10.0)
      expect(intersecting_frame).not_to be_valid
      expect(intersecting_frame.errors[:base]).to include(/intersect/i)
    end
  end
end
