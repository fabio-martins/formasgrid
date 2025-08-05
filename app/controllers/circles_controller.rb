class CirclesController < ApplicationController
  before_action :set_frame, only: [:create, :index]
  before_action :set_circle, only: [:update, :destroy]

  def create
    @circle = @frame.circles.new(circle_params)
    if @circle.save
      render json: @circle, serializer: CircleSerializer, status: :created
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def update
    if @circle.update(circle_params)
      render json: @circle, serializer: CircleSerializer
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def index
    if params[:frame_id].present?
      @frame = Frame.find(params[:frame_id])
      circles = @frame.circles
    else
      circles = Circle.all
    end

    service = CircleFilterService.call(circles: circles,
                                       center_x: params[:center_x],
                                       center_y: params[:center_y],
                                       radius: params[:radius])

    if service.success?
      render json: { circles: service.data[:result] }, root: "circles", adapter: :json
    else
      render json: { error: service.data[:errors] }, status: :unprocessable_content
    end
  end

  def destroy
    @circle.destroy
    head :no_content
  end

  private

  def set_frame
    @frame = Frame.find(params[:frame_id])
  end

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
