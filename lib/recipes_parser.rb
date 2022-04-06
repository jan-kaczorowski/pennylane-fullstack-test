# frozen_string_literal: true

class RecipesParser
  UNIT_REGEX = /(cup|teaspoon|package|pound|tablespoon|pinch)/
  QUANTITY_REGEX = /^[0-9\.]+/

  VULGAR_TO_FLOAT = {
    "\u00BC" => 1.0 / 4.0,
    "\u00BD" => 1.0 / 2.0,
    "\u00BE" => 3.0 / 4.0,
    "\u2150" => 1.0 / 7.0,
    "\u2151" => 1.0 / 9.0,
    "\u2152" => 1.0 / 10.0,
    "\u2153" => 1.0 / 3.0,
    "\u2154" => 2.0 / 3.0,
    "\u2155" => 1.0 / 5.0,
    "\u2156" => 2.0 / 5.0,
    "\u2157" => 3.0 / 5.0,
    "\u2158" => 4.0 / 5.0,
    "\u2159" => 1.0 / 6.0,
    "\u215A" => 5.0 / 6.0,
    "\u215B" => 1.0 / 8.0,
    "\u215C" => 3.0 / 8.0,
    "\u215D" => 5.0 / 8.0,
    "\u215E" => 7.0 / 8.0,
    "\u2189" => 0.0 / 3.0,
  }

  def self.call
    new.call
  end

  def call
    load_file

    data.each do |recipe_attrs|
      @recipe_attrs = recipe_attrs

      process_recipe_attrs
    end
  end

  attr_reader :data, :recipe_attrs

  def load_file
    file_contents = File.read(file_path)
    @data = JSON.parse(file_contents)
  end

  def process_recipe_attrs
    ingredients = find_or_create_ingredients
    create_recipe(ingredients)
  end

  def find_or_create_ingredients
    ingredients = Set.new

    recipe_attrs['ingredients'].each do |ingredient_row|
      # remove unnecessary ending adjectives
      main_part_ingredient_row = ingredient_row.split(',').first

      # remove content in brackets (not important)
      main_part_ingredient_row.gsub!(/[\[|\(](.*?)[\]|\)]/,'')

      # convert vulgar fractions
      vulgar_fractions_to_simple(main_part_ingredient_row)

      unit_matches = main_part_ingredient_row.match(UNIT_REGEX)
      quantity_matches = main_part_ingredient_row.match(QUANTITY_REGEX)
      unit = unit_matches ? unit_matches[0] : 'piece'
      quantity = quantity_matches ? quantity_matches[0] : -1

      ingredient_name = if unit_matches
        main_part_ingredient_row.split(/(cups?|teaspoons?|packages?|pounds?|tablespoons?|pinch)/).last.strip
      else
        main_part_ingredient_row.gsub(/\d+/,'').strip
      end

      puts ingredient_name

      ingr = Ingredient.find_or_initialize_by(name: ingredient_name)
      ingr.save! unless ingr.persisted?
      attrs = { ingr_id: ingr.id, unit: unit, quantity: quantity, mauled_row: main_part_ingredient_row, original_row: ingredient_row }
      puts attrs
      ingredients.add(attrs)
    end

    ingredients
  end

  def create_recipe(ingredients)
    recipe = Recipe.new(
      title: recipe_attrs['title'],
      cook_time: recipe_attrs['cook_time'],
      prep_time: recipe_attrs['prep_time'],
      ratings: recipe_attrs['ratings'],
      cuisine: recipe_attrs['cuisine'].empty? ? nil : recipe_attrs['cuisine'],
      author: recipe_attrs['author'],
      image_url: recipe_attrs['image']
    )
    recipe.save!

    ingredients.each do |attrs|
      RecipeIngredientAssignment.create!(
        recipe: recipe,
        ingredient_id: attrs[:ingr_id],
        unit: attrs[:unit],
        quantity: attrs[:quantity],
        original_row: attrs[:original_row]
      )
    end
  end

  def vulgar_fractions_to_simple(string)
    VULGAR_TO_FLOAT.each do |key, val|
      next unless string.include?(key)

      string.gsub!(key, val.round(2).to_s)
    end
  end

  def file_path
    Rails.root.join('recipes-en.json')
  end
end
