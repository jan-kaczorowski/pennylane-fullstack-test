# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

  end

  def recipes_for_ingredients
    render json: {
      input: params.permit!.to_h,
      recipes: [
        {
          id: 1,
          name: 'Recipe 1',
          rating: 5.0
        },
        {
          id: 2,
          name: 'Recipe 2',
          rating: 4.0
        }
      ]
    }
  end

  def ingredients_list
    render json: Ingredient.select(:id,:name)
                           .map(&:attributes)
                           .as_json
  end
end
