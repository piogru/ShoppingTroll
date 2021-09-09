class CapacityController < ApplicationController
  def index; end

  def calculate_capacity
    unless params[:label].present? && params[:product_id].present?
      render_capacity_result(alert_message: I18n.t("capacity_calculator.capacity_label_prod_error"))
      return
    end

    if !(params[:input].empty?) && (@capacity_result = capacity_result(capacity_params))
      render_capacity_result
    else
      render_capacity_result(alert_message: I18n.t("capacity_calculator.capacity_value_error"))
    end
  end

  def calculate_form
    unless params[:home_form].present? && params[:recipe_form].present?
      render_form_result(alert_message: I18n.t("capacity_calculator.form_type_error"))
      return
    end

    if (params[:home_form_x].present? && params[:recipe_form_x].present?)
      calculate_form_area
    else
      render_form_result(alert_message: I18n.t("capacity_calculator.form_dim_error"))
    end
  end

  private

  def render_capacity_js(partial:, alert_message: nil)
    respond_to do |format|
      if alert_message
        flash.now[:alert] = alert_message
      end
      format.js { render partial: partial }
    end
  end

  def render_form_js(partial:, alert_message: nil)
    respond_to do |format|
      if alert_message
        flash.now[:alert] = alert_message
      end
      format.js { render partial: partial }
    end
  end

  def render_capacity_result(alert_message: nil)
    render_capacity_js(partial: "capacity/capacity_result", alert_message: alert_message)
  end

  def render_form_result(alert_message: nil)
    render_form_js(partial: "capacity/form_result", alert_message: alert_message)
  end

  def capacity_params
    params.slice(:label, :product_id, :input)
  end

  def capacity_result(capacity_params)
    calculator_input = CalculatorInput.new(capacity_params)
    CalculatorServices::CapacityCalculatorService.for(capacity_params["label"]).call(calculator_input)
  end

  def product_ratio_params
    params.slice(:recipe_form, :recipe_form_x, :home_form, :home_form_x, :recipe_form_y, :home_form_y)
  end

  def calculate_product_ratio
    CalculatorServices::ProductRatioService.call(product_ratio_params)
  end

  def calculate_form_area
    if (params[:home_form].eql?("mold") && params[:home_form_y].empty?) ||
        (params[:recipe_form].eql?("mold") && params[:recipe_form_y].empty?)
      render_form_result(alert_message: I18n.t("capacity_calculator.form_dim_error"))
    else
      @product_ratio = calculate_product_ratio
      render_form_result
    end
  end
end
