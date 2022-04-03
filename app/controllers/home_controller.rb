# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

  end

  def recipes_for_ingredients
    render json: {
      input: params.permit!.to_h,
      recipes: Recipe.includes(:ingredients).order(ratings: :desc).limit(10).as_json(include: :ingredients)
    }
  end

  def ingredients_list
    render json: Ingredient.select(:id,:name)
                           .map(&:attributes)
                           .as_json
  end
end
