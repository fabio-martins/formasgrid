class SquaresController < ApplicationController
  before_action :set_square, only: [ :show, :destroy ]

  def create
    @square = Square.new(square_params)
    if @square.save
      create_circles if params[:circles].present?
      render json: @square, serializer: SquareSerializer, status: :created
    else
      render json: @square.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @square, serializer: SquareSerializer
  end

  def destroy
    if @square.circles.empty?
      @square.destroy
      head :no_content
    else
      render json: { error: "Cannot delete square with associated circles." }, status: :unprocessable_entity
    end
  end

  private

  def set_square
    @square = Square.find(params[:id])
  end

  def square_params
    params.require(:square).permit(:center_x, :center_y, :width, :height)
  end

  def create_circles
    params[:circles].each do |circle_params|
      @square.circles.create(circle_params.permit(:center_x, :center_y, :diameter))
    end
  end
end
