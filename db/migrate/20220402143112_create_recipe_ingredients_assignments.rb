class CreateRecipeIngredientsAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_ingredient_assignments do |t|
      t.references :recipe, foreign_key: true, index: true
      t.references :ingredient, foreign_key: true, index: true
      t.integer :unit, null: false, index: true
      t.float :quantity, null: false, index: true
      t.string :original_row
    end
  end
end
