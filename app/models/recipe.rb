# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipe_ingredient_assignments
  has_many :ingredients, through: :recipe_ingredient_assignments
end
