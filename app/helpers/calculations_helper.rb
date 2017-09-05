require 'rest_client'
require 'json'
require 'date'

module CalculationsHelper

  API_BASE_URL = "http://api.fixer.io/"

  def get_rate(date, base, target)
    uri = make_uri(date, base, target)
    data = get_cached_data(uri)
    data['rates'][target]
  end

  def find_rank(data)
    data
  end

  protected

  def get_cached_data(uri)
    Rails.cache.fetch(uri, {:expires_in => 24.hours, :raw => true}) { JSON.parse(RestClient::Resource.new(uri).get) }
  end

  def make_uri(date, base, target)
    API_BASE_URL + date.to_s + "?" + {
        "base" => base,
        "symbols" => target
    }.to_query
  end
end
