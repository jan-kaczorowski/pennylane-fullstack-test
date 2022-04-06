# frozen_string_literal: true

class RecipeIngredientAssignment < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  enum unit: {
    cup: 0,
    pound: 1,
    spoon: 2,
    package: 3,
    pinch: 4,
    teaspoon: 5,
    piece: 6,
    tablespoon: 7
  }

end
