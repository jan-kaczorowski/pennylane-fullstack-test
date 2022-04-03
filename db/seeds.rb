require 'recipes_parser'

return unless Recipe.none? && Ingredient.none?

RecipesParser.call