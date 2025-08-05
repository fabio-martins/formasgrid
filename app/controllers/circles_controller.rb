class CirclesController < ApplicationController
  before_action :set_square, only: [ :create, :index ]
  before_action :set_circle, only: [ :update, :destroy ]

  def create
    @circle = @square.circles.new(circle_params)
    if @circle.save
      render json: @circle, serializer: CircleSerializer, status: :created
    else
      render json: @circle.errors, status: :unprocessable_entity
    end
  end

  def update
    if @circle.update(circle_params)
      render json: @circle, serializer: CircleSerializer
    else
      render json: @circle.errors, status: :unprocessable_entity
    end
  end

  def index
    service = CircleFilterService.call(circles:  @square.circles,
                                       center_x: params[:center_x],
                                       center_y: params[:center_y],
                                       radius:   params[:radius])

    if service.success?
      render json: { circles: service.data[:result] }, root: "circles", adapter: :json
    else
      render json: { error: service.data[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    @circle.destroy
    head :no_content
  end

  private

  def set_square
    @square = Square.find(params[:square_id])
  end

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
