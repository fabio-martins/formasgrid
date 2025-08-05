require 'rails_helper'

RSpec.describe V1::CirclesController, type: :request do
  let!(:frame)   { create(:frame, center_x: 20, center_y: 20, width: 50, height: 50) }
  let!(:circle)  { create(:circle, frame: frame, center_x: 10, center_y: 10, radius: 4) }
  let!(:circle2) { create(:circle, frame: frame, center_x: 20, center_y: 10, radius: 4) }

  describe "PUT /v1/circles/:id" do
    it "updates the circle" do
      params = { circle: { center_x: 30, center_y: 30, radius: circle.radius } }
      put "/v1/circles/#{circle.id}", params: params, as: :json

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json).to include("center_x" => 30.0, "center_y" => 30.0)
    end

    it "returns errors for invalid data" do
      params = { circle: { radius: -1, center_x: circle.center_x, center_y: circle.center_y } }
      put "/v1/circles/#{circle.id}", params: params, as: :json

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:unprocessable_content)
      expect(response.parsed_body).not_to be_empty
    end
  end

  describe "GET /circles" do
    before do
      allow(CircleFilterService).to receive(:call).and_return(
        OpenStruct.new(success?: true, data: { result: [ circle, circle2 ] })
      )
    end

    it "returns circles for global filter with frame_id and position" do
      get "/v1/circles", params: {
        center_x: 20, center_y: 20, radius: 20, frame_id: frame.id
      }

      expect(response).to have_http_status(:ok)
      circles = response.parsed_body
      expect(circles.map { |c| c["id"] }).to match_array([ circle.id, circle2.id ])
    end

    it "returns error if service fails" do
      allow(CircleFilterService).to receive(:call).and_return(
        OpenStruct.new(success?: false, data: { error: "Invalid params" })
      )

      get "/v1/circles", params: {
        center_x: nil, center_y: nil, radius: nil, frame_id: frame.id
      }

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:unprocessable_content)
      expect(response.parsed_body).to include("error" => "Invalid params")
    end
  end

  describe "DELETE /circles/:id" do
    it "deletes the circle" do
      expect {
        delete "/v1/circles/#{circle.id}", as: :json
      }.to change(Circle, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
