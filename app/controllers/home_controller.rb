# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def recipes_for_ingredients
    recipes = RecipesFetcher.call(params['ingredients'])
    render json: { recipes: recipes }
  end
end
