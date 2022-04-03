# frozen_string_literal: true

class RecipeIngredientAssignment < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
end
