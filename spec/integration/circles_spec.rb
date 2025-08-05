require 'swagger_helper'

RSpec.describe 'Circles API', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/v1/circles' do
    get 'List circles with filters' do
      tags 'Circles'
      produces 'application/json'
      parameter name: :center_x, in: :query, type: :number, required: false
      parameter name: :center_y, in: :query, type: :number, required: false
      parameter name: :radius,   in: :query, type: :number, required: false
      parameter name: :frame_id, in: :query, type: :integer, required: false

      response '200', 'circles found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id:        { type: :integer },
            center_x:  { type: :number },
            center_y:  { type: :number },
            radius:    { type: :number },
            frame_id:  { type: :integer }
          }
        }

        let!(:frame_obj)   { create(:frame, center_x: 20, center_y: 20, width: 50, height: 50) }
        let!(:circle_obj1) { create(:circle, frame: frame_obj, center_x: 10, center_y: 10, radius: 4) }
        let!(:circle_obj2) { create(:circle, frame: frame_obj, center_x: 20, center_y: 10, radius: 4) }
        let(:center_x) { 10 }
        let(:center_y) { 10 }
        let(:radius)   { 15 }
        let(:frame_id) { frame_obj.id }

        run_test!
      end
    end
  end

  path '/v1/circles/{id}' do
    parameter name: :id, in: :path, type: :integer

    put 'Update a circle' do
      tags 'Circles'
      consumes 'application/json'
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number },
          center_y: { type: :number },
          radius:   { type: :number }
        }
      }

      response '200', 'circle updated' do
        let!(:frame_obj) { create(:frame) }
        let!(:circle_obj) { create(:circle, frame: frame_obj) }
        let(:id) { circle_obj.id }
        let(:circle) { { center_x: 30, center_y: 30, radius: 4 } }
        run_test!
      end

      response '422', 'invalid update' do
        let!(:frame_obj) { create(:frame) }
        let!(:circle_obj) { create(:circle, frame: frame_obj) }
        let(:id) { circle_obj.id }
        let(:circle) { { radius: -1 } }
        run_test!
      end
    end

    delete 'Delete a circle' do
      tags 'Circles'
      response '204', 'circle deleted' do
        let!(:frame_obj) { create(:frame) }
        let!(:circle_obj) { create(:circle, frame: frame_obj) }
        let(:id) { circle_obj.id }
        run_test!
      end
    end
  end

  path '/v1/frames/{frame_id}/circles' do
    parameter name: :frame_id, in: :path, type: :integer

    post 'Create a circle in a frame' do
      tags 'Circles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          center_x: { type: :number },
          center_y: { type: :number },
          radius:   { type: :number }
        },
        required: [ 'center_x', 'center_y', 'radius' ]
      }

      response '201', 'circle created' do
        let!(:frame) { create(:frame) }
        let(:frame_id) { frame.id }
        let(:circle) { { center_x: 10, center_y: 10, radius: 5 } }

        run_test!
      end

      response '422', 'invalid request' do
        let!(:frame) { create(:frame) }
        let(:frame_id) { frame.id }
        let(:circle) { { center_x: nil, center_y: nil, radius: nil } }
        run_test!
      end
    end
  end
end
