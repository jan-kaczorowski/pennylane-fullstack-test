# frozen_string_literal: true

class RecipesFetcher
  FIELDS = %i[
    id title ratings relevance intersecting_ids searched_for_ids
    cook_time prep_time cuisine author title image_url
  ]
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params
    @ingredient_ids = []
  end

  def call
    find_ingredients_from_params

    Recipe.joins("INNER JOIN (#{results_sql}) AS results ON recipes.id = results.id")
          .includes(:recipe_ingredient_assignments, :ingredients)
          .select(*FIELDS)
          .order(relevance: :desc)
          .as_json(include: :recipe_ingredient_assignments)
  end

  private

  def find_ingredients_from_params
    params.split(',').each do |ingr_string|
      ingr_string.strip!
      ingr = Ingredient.where("name ILIKE '%#{ingr_string}%'").first
      ingredient_ids.push(ingr.id) if ingr
    end
  end

  def results_sql(limit = 30)
    <<-SQL.squish
        SELECT
        rec.id,
        rec.title,
        rd.intersecting_ids,
        rd.searched_for_ids,
        array_length(rd.intersecting_ids, 1) * 100 / array_length(rd.searched_for_ids, 1) AS relevance
      FROM recipes rec JOIN (
        (
          SELECT
            r.id,
            (
              select array_agg(e)
                from (
                    select unnest(ARRAY [#{ingredient_ids.join(',')}]::bigint[] )
                    intersect
                    select unnest(array_agg(ria.ingredient_id))
                ) as dt(e)
            ) as intersecting_ids,
            ARRAY [#{ingredient_ids.join(',')}]::bigint[] as searched_for_ids,
            array_agg(ria.ingredient_id) AS ingredient_ids
          FROM recipes r LEFT JOIN recipe_ingredient_assignments ria ON ria.recipe_id = r.id
          GROUP BY r.id
        )
      ) AS rd ON rec.id = rd.id
      WHERE array_length(rd.intersecting_ids, 1) IS NOT NULL
      ORDER BY (
        array_length(rd.intersecting_ids, 1) * 100 / array_length(rd.searched_for_ids, 1)
      ) DESC, title ASC
      LIMIT #{limit}
    SQL
  end

  attr_reader :params, :ingredient_ids
end
