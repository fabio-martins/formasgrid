class CirclesController < ApplicationController
  before_action :set_circle, only: [ :update, :destroy ]

  def index
    if params[:frame_id]
      circles = Frame.find(params[:frame_id]).circles
    else
      circles = Circle.all
    end

    service = CircleFilterService.call(circles:  circles,
                                       center_x: params[:center_x]&.to_f,
                                       center_y: params[:center_y]&.to_f,
                                       radius:   params[:radius]&.to_f)
    if service.success?
      render json: service.data[:result], each_serializer: CircleSerializer
    else
      render json: { error: service.data[:error] }, status: :unprocessable_content
    end
  end

  def update
    if @circle.update(circle_params)
      render json: @circle, serializer: CircleSerializer
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def destroy
    @circle.destroy
    head :no_content
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:frame_id, :center_x, :center_y, :radius)
  end
end
