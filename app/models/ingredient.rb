# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipe_ingredient_assignments
  has_many :recipes, through: :recipe_ingredient_assignments
end
