class CalculatorInput
  include ActiveModel::Validations

  attr_reader :product_id, :input

  def initialize(params)
    raise ArgumentError, "Missing params hash" if params.nil?

    @product_id = params[:product_id]
    @input = params[:input]
  end

  validates :product_id, presence: true
  validates :input, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :product_must_exist

  private

  def product_must_exist
    unless Product.exists?(@product_id)
      errors.add(:product_id, "must exist in database")
    end
  end
end
