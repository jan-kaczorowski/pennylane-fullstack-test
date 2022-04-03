# frozen_string_literal: true

class RecipesParser
  def self.call
    new.call
  end

  def initialize
    @ingredients = Set.new
  end

  def call
    load_file

    data.each do |recipe_attrs|
      @recipe_attrs = recipe_attrs
      process_recipe_attrs
    end

    puts ingredients.size
    ingredients
  end

  attr_reader :data, :recipe_attrs, :ingredients

  def load_file
    file_contents = File.read(file_path)
    @data = JSON.parse(file_contents)
  end

  def process_recipe_attrs
    ingredient_ids = find_or_create_ingredients
    create_recipe(ingredient_ids)
  end

  def find_or_create_ingredients
    ingredient_ids = []

    recipe_attrs['ingredients'].each do |ingredient_row|
      # remove unnecessary ending adjectives
      main_part_ingredient_row = ingredient_row.split(',').first
      # remove vulgar fractions
      main_part_ingredient_row.gsub!(/[\u2150-\u215E\u00BC-\u00BE]/,'')
      # remove content in brackets
      main_part_ingredient_row.gsub!(/[\[|\(](.*?)[\]|\)]/,'')
      # remove units/quantities part
      title = if %w[cup pound spoon package pinch].any? { |unit| main_part_ingredient_row.include?(unit) }
        main_part_ingredient_row.split(/(cups?|teaspoons?|packages?|pounds?|tablespoons?|pinch)/).last.strip
      else
        main_part_ingredient_row.gsub(/\d+/,'').strip
      end

      puts title
      ingredients.add(title)

      ingr = Ingredient.find_or_initialize_by(name: title)
      ingr.save! unless ingr.persisted?

      ingredient_ids.push(ingr.id)
    end

    ingredient_ids
  end

  def create_recipe(ingredient_ids)
    Recipe.create!(
      title: recipe_attrs['title'],
      cook_time: recipe_attrs['cook_time'],
      prep_time: recipe_attrs['prep_time'],
      ingredient_ids: ingredient_ids,
      ratings: recipe_attrs['ratings'],
      cuisine: recipe_attrs['cuisine'].empty? ? nil : recipe_attrs['cuisine'],
      author: recipe_attrs['author'],
      image_url: recipe_attrs['image']
    )
  end

  def file_path
    Rails.root.join('recipes-en.json')
  end
end
