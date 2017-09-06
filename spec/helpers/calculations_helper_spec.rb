require "rails_helper"
require 'json'

RSpec.describe CalculationsHelper, type: :helper do
  describe "helper" do
    it "should get rate" do
      uri = "http://api.fixer.io/2017-08-29?base=USD&symbols=EUR"
      data = JSON.parse('{"base":"USD","date":"2017-08-29","rates":{"EUR":0.001}}')

      expect(helper).to receive(:make_uri).with('2017-08-29', 'USD', 'EUR').and_return(uri)
      expect(helper).to receive(:get_cached_data).with(uri).and_return(data)
      expect(helper.get_rate('2017-08-29', 'USD', 'EUR')).to eq(0.001)
    end

    it "should find rank" do
      in_data = [{"profit_loss" => 10, "id" => 1},{"profit_loss" => 15, "id" => 2},{"profit_loss" => 5, "id" => 3}]
      in_data_sorted = [{"profit_loss" => 15, "id" => 2},{"profit_loss" => 10, "id" => 1}, {"profit_loss" => 5, "id" => 3}]
      out_data_sorted = [{"profit_loss" => 15, "id" => 2, "rank" => 1 }, {"profit_loss" => 10, "id" => 1, "rank" => 2}, {"profit_loss" => 5, "id" => 3, "rank" => 3}]
      out_data = [{"profit_loss" => 10, "id" => 1, "rank" => 2}, {"profit_loss" => 15, "id" => 2, "rank" => 1 }, {"profit_loss" => 5, "id" => 3, "rank" => 3}]

      expect(helper).to receive(:sort_by_rank).with(in_data).and_return(in_data_sorted)
      expect(helper).to receive(:sort_by_week).with(out_data_sorted).and_return(out_data)
      expect(helper.find_rank(in_data)).to eq(out_data)
    end

    it "should get week_ago_text" do

      expect(helper.week_ago_text(0)).to eq("this week")
      expect(helper.week_ago_text(1)).to eq("1 week ago")
      expect(helper.week_ago_text(5)).to eq("5 weeks ago")
    end

    it "should convert data to graph format" do
      in_data = [{"profit_loss" => 10, "year" => 2017, "week" => 10},{"profit_loss" => 15, "year" => 2017, "week" => 11}]
      out_data = {"2017 / 10"=>10, "2017 / 11"=>15}

      expect(helper.data_to_graph_format(in_data)).to eq(out_data)
    end
  end
end