require 'rails_helper'

RSpec.describe V1::FramesController, type: :request do
  let(:valid_frame_params) do
    {
      frame: {
        center_x: 10.5,
        center_y: 20.5,
        width: 40.0,
        height: 40.0
      }
    }
  end

  describe "POST /frames" do
    context "with valid params" do
      it "creates a frame" do
        expect {
          post "/v1/frames", params: valid_frame_params, as: :json
        }.to change(Frame, :count).by(1)

        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json).to include("center_x" => 10.5, "center_y" => 20.5, "width" => 40.0, "height" => 40.0)
        expect(json["id"]).to be_present
      end

      it "creates a frame with circles" do
        params = valid_frame_params.deep_merge(
          circles: [
            { center_x: 10.0, center_y: 10.0, radius: 4.0 },
            { center_x: 20.0, center_y: 10.0, radius: 4.0 }
          ]
        )

        expect {
          post "/v1/frames", params: params, as: :json
        }.to change(Frame, :count).by(1)
         .and change(Circle, :count).by(2)

        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json["id"]).to be_present
      end
    end

    context "with invalid params" do
      it "returns :unprocessable_content" do
        params = { frame: { center_x: nil, center_y: nil } }
        post "/v1/frames", params: params, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to be_a(Hash)
      end
    end
  end

  describe "GET /frames/:id" do
    let!(:frame) { create(:frame, center_x: 5, center_y: 5, width: 20, height: 20) }

    it "returns the frame" do
      get "/v1/frames/#{frame.id}", as: :json
      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json).to include("center_x" => 5.0, "center_y" => 5.0)
      expect(json["id"]).to eq(frame.id)
    end
  end

  describe "DELETE /frames/:id" do
    context "when frame has no circles" do
      let!(:frame) { create(:frame, center_x: 1, center_y: 2, width: 10, height: 10) }

      it "deletes the frame" do
        expect {
          delete "/v1/frames/#{frame.id}", as: :json
        }.to change(Frame, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when frame has circles" do
      let!(:frame) { create(:frame, center_x: 1, center_y: 2, width: 10, height: 10) }
      let!(:circle) { create(:circle, frame: frame, center_x: 2, center_y: 3, radius: 2) }

      it "does not delete the frame" do
        expect {
          delete "/v1/frames/#{frame.id}", as: :json
        }.not_to change(Frame, :count)
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to include("error" => "Cannot delete frame with associated circles.")
      end
    end
  end
end
