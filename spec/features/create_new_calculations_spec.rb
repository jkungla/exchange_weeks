require 'rails_helper'

RSpec.feature "CreateNewCalculations", type: :feature do
  before :each do
    @controller = CalculationsController.new
  end

  it "should require the user log in before creating new calculation" do
    password = "123456789"
    u = create( :user, password: password, password_confirmation: password )

    visit new_calculation_path

    within "#new_user" do
      fill_in "user_email", with: u.email
      fill_in "user_password", with: password
    end

    click_button "Log in"

    within "#new_calculation" do
      select "USD", from: "calculation_base"
      select "EUR", from: "calculation_target"
      fill_in "calculation_amount", with: 17000.00
      fill_in "calculation_wait_time", with: 25
    end

    allow(@controller).to receive(:redirect_to)

    click_link_or_button "Calculate"

    expect( Calculation.count ).to eq(1)
    expect( Calculation.first.base).to eq("USD")
  end

  it "should create a new calculation with a logged in user" do
    login_as create( :user ), scope: :user

    visit new_calculation_path
    # puts page.body

    within "#new_calculation" do
      select "USD", from: "calculation_base"
      select "EUR", from: "calculation_target"
      fill_in "calculation_amount", with: 17000.00
      fill_in "calculation_wait_time", with: 25
    end

    allow(@controller).to receive(:redirect_to)

    click_link_or_button "Calculate"

    expect( Calculation.count ).to eq(1)
    expect( Calculation.first.base).to eq("USD")
  end
end
