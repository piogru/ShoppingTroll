class RecipeFetcher < ApplicationService
  require "net/http"
  API_URL = ENV["RECIPE_API_URL"]

  def initialize(recipe_id)
    raise ArgumentError if !recipe_id || recipe_id.empty?
    @url = URI(API_URL + recipe_id)
  end

  def call
    JSON.parse(get_api_response.body)
  end

  private

  def get_api_response
    Net::HTTP.get_response(@url)
  end
end
