module V1
  class FramesController < ApplicationController
    before_action :set_frame, only: [ :show, :destroy ]

    def create
      @frame = Frame.new(frame_params)
      if @frame.save
        create_circles if params[:circles].present?
        render json: @frame, serializer: FrameSerializer, status: :created
      else
        render json: @frame.errors, status: :unprocessable_content
      end
    end

    def show
      render json: @frame, serializer: FrameSerializer
    end

    def destroy
      if @frame.circles.empty?
        @frame.destroy
        head :no_content
      else
        render json: { error: "Cannot delete frame with associated circles." }, status: :unprocessable_content
      end
    end

    private

    def set_frame
      @frame = Frame.find(params[:id])
    end

    def frame_params
      params.require(:frame).permit(:center_x, :center_y, :width, :height)
    end

    def create_circles
      params[:circles].each do |circle_params|
        @frame.circles.create(circle_params.permit(:center_x, :center_y, :radius))
      end
    end
  end
end
