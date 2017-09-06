require 'rest_client'
require 'json'
require 'date'

module CalculationsHelper

  API_BASE_URL = "http://api.fixer.io/"

  # gets exchange rate for iserted date from fixer.io api
  def get_rate(date, base, target)
    uri = make_uri(date, base, target)
    data = get_cached_data(uri)
    data['rates'][target]
  end

  def find_rank(data)
    sorted_data = sort_by_rank(data)
    3.times do |rank|
      sorted_data[rank]["rank"] = rank + 1
    end
    sort_by_week(sorted_data)
  end

  def week_ago_text(week)
    if week == 0
      "this week"
    elsif week == 1
      "1 week ago"
    else
      "#{week.to_s} weeks ago"
    end
  end

  def data_to_graph_format(data)
    graph = {}
    data.each do |week|
      graph[week["year"].to_s + " / " + week["week"].to_s] = week["profit_loss"]
    end
    graph
  end

  protected

  # saves querys in Cache for 24 hours
  def get_cached_data(uri)
    Rails.cache.fetch(uri, {expires_in: 24.hours, raw: true}) { JSON.parse(RestClient::Resource.new(uri).get) }
  end

  def make_uri(date, base, target)
    API_BASE_URL + date.to_s + "?" + {
        "base" => base,
        "symbols" => target
    }.to_query
  end

  def sort_by_rank(data)
    data.sort {|a,b| b["profit_loss"] <=> a["profit_loss"]}
  end

  def sort_by_week(data)
    data.sort {|a,b| a["id"] <=> b["id"]}
  end
end
