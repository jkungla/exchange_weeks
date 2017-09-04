class CalculationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @calculation = Calculation.new
  end

  def show
    @calculation = Calculation.find(params[:id])
  end

  def create
    @calculation = Calculation.new(calculation_params)

    @calculation.save
    redirect_to @calculation
  end

  private
  def calculation_params
    params.require(:calculation).permit(:base, :target, :amount, :wait_time)
  end
end
