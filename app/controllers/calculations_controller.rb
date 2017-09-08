class CalculationsController < ApplicationController
  include CalculationsHelper
  before_action :authenticate_user!
  before_action :all_calculations, :only => [:index, :new, :edit]

  def index
    redirect_to new_calculation_path
  end

  def new
    @calculation = Calculation.new
  end

  def edit
    @calculation = Calculation.find(params[:id])
    render action: 'new'
  end

  def show
    @calculation = Calculation.find(params[:id])
    return unless @calculation

    @data = []
    todays_exchange = 0

    # loop for inserted "wait_time" times
    @calculation.wait_time.times do |time|
      date = Time.now - time.weeks
      rate = get_rate(date.beginning_of_week.strftime('%F'),
                      @calculation.base, @calculation.target)

      # Finding todays exchange amount for calculating profit/loss
      todays_exchange = rate * @calculation.amount.to_f if todays_exchange.zero?

      @data << {
          'week' => date.strftime('%U').to_i,
          'year' => date.year, 'id' => time,
          'rate' => rate, 'week_ago' => week_ago_text(time), 'rank' => '',
          'exchange_amount' => (@calculation.amount.to_f * rate.to_f).round(2),
          'profit_loss' => ((@calculation.amount.to_f * rate.to_f) - todays_exchange.to_f).round(2)
      }
    end

    @data = find_rank(@data)
    @graph_data = data_to_graph_format(@data)
  end

  def create
    @calculation = Calculation.new(calculation_params)
    if @calculation.save
      redirect_to @calculation
    else
      flash[:error] = @calculation.errors.full_messages.first
      render action: 'new'
    end
  end

  def update
    @calculation = Calculation.new(calculation_params)
    if @calculation.save
      redirect_to @calculation
    else
      flash[:error] = @calculation.errors.full_messages.first
      render action: 'new'
    end
  end

  def destroy
    @calculation = Calculation.find(params[:id])
    @calculation.destroy
    respond_to do |format|
      format.html { redirect_to new_calculation_path }
      format.xml  { head :ok }
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:base, :target, :amount, :wait_time)
  end

  def all_calculations
    @calculations ||= Calculation.all
  end
end
