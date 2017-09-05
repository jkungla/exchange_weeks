class CalculationsController < ApplicationController
  include CalculationsHelper
  before_action :authenticate_user!

  def new
    @calculation = Calculation.new
  end

  def show
    @calculation = Calculation.find(params[:id])
    if @calculation
      @data = []
      @calculation.wait_time.times do |time|
        date = Time.now - time.weeks
        week_nr = date.strftime("%U").to_i
        year = date.year
        date = date.beginning_of_week.strftime("%F") # Use the weeks first day for better cache usage
        @data << {"week" => week_nr, "year" => year, "rate" => get_rate(date, @calculation.base, @calculation.target)}
      end
      @data = find_rank(@data)
    end
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
