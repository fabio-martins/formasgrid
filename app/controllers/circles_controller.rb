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
    @circles = @square.circles
    if params[:center_x].present? && params[:center_y].present? && params[:radius].present?
      @circles = @circles.select do |circle|
        distance = Math.sqrt((circle.center_x - params[:center_x].to_f)**2 + (circle.center_y - params[:center_y].to_f)**2)
        distance <= params[:radius].to_f
      end
    end
    render json: @circles, each_serializer: CircleSerializer
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
