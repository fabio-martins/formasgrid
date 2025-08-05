require 'swagger_helper'

RSpec.describe 'Frames API', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/frames' do
    post 'Create a frame' do
      tags 'Frames'
      consumes 'application/json'
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number },
          center_y: { type: :number },
          width:    { type: :number },
          height:   { type: :number },
          circles: {
            type: :array,
            items: {
              type: :object,
              properties: {
                center_x: { type: :number },
                center_y: { type: :number },
                radius:   { type: :number }
              }
            }
          }
        },
        required: %w[center_x center_y width height]
      }

      response '201', 'frame created' do
        let(:frame) do
          {
            center_x: 10.5,
            center_y: 20.5,
            width:    40.0,
            height:   40.0
          }
        end
        run_test!
      end

      response '201', 'frame with circles created' do
        let(:frame) do
          {
            center_x: 10.5,
            center_y: 20.5,
            width:    40.0,
            height:   40.0,
            circles: [
              { center_x: 10.0, center_y: 10.0, radius: 4.0 },
              { center_x: 20.0, center_y: 10.0, radius: 4.0 }
            ]
          }
        end
        run_test!
      end

      response '422', 'invalid params' do
        let(:frame) { { center_x: nil, center_y: nil } }
        run_test!
      end
    end
  end

  path '/frames/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a frame' do
      tags 'Frames'
      produces 'application/json'
      response '200', 'frame found' do
        let(:id) { Frame.create!(center_x: 5, center_y: 5, width: 20, height: 20).id }
        run_test!
      end

      response '404', 'frame not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    delete 'Delete a frame' do
      tags 'Frames'
      response '204', 'frame deleted' do
        let(:id) { Frame.create!(center_x: 1, center_y: 2, width: 10, height: 10).id }
        run_test!
      end

      response '422', 'cannot delete frame with circles' do
        let(:id) do
          frame = Frame.create!(center_x: 1, center_y: 2, width: 10, height: 10)
          Circle.create!(frame: frame, center_x: 2, center_y: 3, radius: 2)
          frame.id
        end
        run_test!
      end
    end
  end
end
