module CalculatorServices
  class ProductRatioService < ApplicationService
    def initialize(params)
      raise ArgumentError, "Missing params hash" if params.nil?

      @recipe_form = params[:recipe_form]
      @recipe_form_x = params[:recipe_form_x]
      @home_form = params[:home_form]
      @home_form_x = params[:home_form_x]
      @recipe_form_y = params[:recipe_form_y]
      @home_form_y = params[:home_form_y]

      check_params_presence
      check_params_value
    end

    def call
      recipe_area = calculate_area(@recipe_form, @recipe_form_x, @recipe_form_y)
      home_area = calculate_area(@home_form, @home_form_x, @home_form_y)
      (home_area / recipe_area).round(2)
    end

    private

    def check_params_presence
      raise ArgumentError, "Missing recipe form" if @recipe_form.empty?
      raise ArgumentError, "Missing recipe form x dimension" if @recipe_form_x.empty?
      raise ArgumentError, "Missing home form" if @home_form.empty?
      raise ArgumentError, "Missing home form x dimension" if @home_form_x.empty?
      raise ArgumentError, "Missing recipe form y dimension" if (@recipe_form.eql?("mold") && @recipe_form_y.empty?)
      raise ArgumentError, "Missing home form y dimension" if (@home_form.eql?("mold") && @home_form_y.empty?)
    end

    def check_params_value
      raise ArgumentError, "Recipe form x dimension cannot be negative" if @recipe_form_x.to_d < 0
      raise ArgumentError, "Home form x dimension cannot be negative" if @home_form_x.to_d < 0
      raise ArgumentError, "Recipe form y dimension cannot be negative" if @recipe_form_y.to_d < 0
      raise ArgumentError, "Home form y dimension cannot be negative" if @home_form_y.to_d < 0
    end

    def calculate_area(form_type, form_x, form_y)
      if form_type == "mold"
        form_x.to_d * form_y.to_d
      else
        form_x.to_d**2 * Math::PI
      end
    end
  end
end
