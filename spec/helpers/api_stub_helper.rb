module Helpers
  def stub_recipe_api_request(recipe_id) # rubocop:disable MethodLength
    uri = Addressable::URI.parse("#{ENV.fetch("RECIPE_API_URL")}#{recipe_id}")
    stub_request(:get, uri).
      to_return do |request|
        if recipe_id == 1
          {
            status:  200,
            headers: { content_type: "application/json" },
            body:    <<~JSON
              {
                "status": 200,
                "type": "Success",
                "data": {
                  "title": "Bread",
                  "ingredients": [
                    { "name": "water", "quantity": 2, "unit": "glass" },
                    { "name": "salt", "quantity": 2, "unit": "teaspoon" },
                    { "name": "flour", "quantity": 1000, "unit": "gram" }
                  ]
                }
              }
            JSON
          }
        else
          {
            status:  404,
            headers: { content_type: "application/json" },
            body:    <<~JSON
              {
                "status": "NOT_FOUND",
                "message": "Couldn't find Recipe with 'id'=#{recipe_id}"
              }
            JSON
          }
        end
      end
  end
end
