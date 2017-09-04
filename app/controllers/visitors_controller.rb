class VisitorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @calculation = Calculation.new
  end
end
