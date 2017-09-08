require "rails_helper"

RSpec.describe CalculationsController, type: :controller do
  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "should be redirected to signin" do
      get :new
      expect( response ).to redirect_to( new_user_session_path )
    end

    it "should let a user see calculation form" do
      login_with create( :user )
      get :new
      expect( response ).to render_template( :new )
    end
  end

  describe "authenticated user" do
    before :each do
      login_with create( :user )
    end

    it "assigns a blank calculation to the view" do
      get :new
      expect(assigns(:calculation)).to be_a_new(Calculation)
    end
  end
end