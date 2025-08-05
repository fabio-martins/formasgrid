class CircleFilterService < ApplicationService
  def call
    binding.pry
    return handle_failure(error: "Center coordinates and radius must be provided.") unless valid_params?

    handle_success(result: filter_circles)
  rescue StandardError => e
    Rails.logger.error("[CircleFilterService]: #{e.class} - #{e.message}")
    handle_failure(error: "An error occurred while filtering circles.")
  end

  private

  def valid_params?
    args[:center_x].present? && args[:center_y].present? && args[:radius].present?
  end

  def filter_circles
    args[:circles].select do |circle|
      distance = Math.sqrt((circle.center_x - args[:center_x])**2 + (circle.center_y - args[:center_y])**2)
      distance <= args[:radius]
    end
  end
end
