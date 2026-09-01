class BoulderSearchService
  ALLOWED_ORDER_FIELDS = %w[ nickname vgrade_range_min vgrade_range_max self_grade type incline ]
  ALLOWED_DIRECTIONS = %w[ ASC DESC ]

  def initialize(search_params)
    @search_params = search_params
  end

  attr_reader :search_params

  def results
    @results ||= perform_search
  end


  private

  def perform_search
    boulders = Boulder.all

    boulders = boulders.with_nickname(search_params[:nickname]) if search_params[:nickname].present?
    boulders = find_grade_range(boulders)
    boulders = boulders.with_type(search_params[:boulder_type]) if search_params[:boulder_type].present?

    boulders.order(order_by => order_direction)
  end

  def find_grade_range(boulders)
    if search_params[:min_grade].present? && search_params[:max_grade].present?
      return boulders.with_grade_range(search_params[:min_grade], search_params[:max_grade])
    elsif search_params[:min_grade].present?
      return boulders.with_grade_range(search_params[:min_grade], search_params[:min_grade])
    elsif search_params[:max_grade].present?
      return boulders.with_grade_range(search_params[:max_grade], search_params[:max_grade])
    elsif search_params[:grade].present?
      return boulders.with_grade_range(search_params[:grade], search_params[:grade])
    end

    boulders
  end

  def order_by
    ALLOWED_ORDER_FIELDS.include?(search_params[:order_by]) ? search_params[:order_by] : :nickname
  end

  def order_direction
    ALLOWED_DIRECTIONS.include?(search_params[:order_direction]&.upcase) ? search_params[:order_direction] : :asc
  end
end