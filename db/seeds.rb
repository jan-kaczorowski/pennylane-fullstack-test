require 'recipes_parser'

# return unless Recipe.none? && Ingredient.none?
RecipeIngredientAssignment.delete_all
Recipe.delete_all
Ingredient.delete_all

RecipesParser.call