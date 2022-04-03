class ApplicationController < ActionController::Base
  def index

  end

  def ingredients_list
    render json: Ingredient.select(:id,:name)
                           .map(&:attributes)
                           .as_json
  end
end
