import PropTypes from 'prop-types'
import React from 'react'

const RecipeDetails = props => (
  <div class="w-full bg-white rounded-lg border border-gray-200 shadow-md dark:bg-gray-800 dark:border-gray-700 mb-6">
    <a href="#">
        <img class="rounded-t-lg" src={props.recipe.image_url} alt="" />
    </a>
    <div class="p-5">
        <a href="#">
            <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
              {props.recipe.title}
            </h5>
        </a>

        <dl className="mb-6 pl-2">
          <dt>Author</dt>
          <dd>{props.recipe.author}</dd>

          <dt>Cuisine</dt>
          <dd>{props.recipe.cuisine}</dd>

          <dt>Prep time</dt>
          <dd>{props.recipe.prep_time}</dd>

          <dt>Cooking time</dt>
          <dd>{props.recipe.cook_time}</dd>
        </dl>

        {props.recipe.ingredients.length > 0 && (
          <>
            <h5 className="mb-2 pl-2">Ingredients:</h5>
            <ul className="list-disc dark:text-gray-400 pl-6">
              {props.recipe.ingredients.map(ingr => {
                return (
                  <li>{ingr.name}</li>
                )
              })}
            </ul>
          </>
        )}
    </div>
  </div>
)

RecipeDetails.defaultProps = {
  recipe: null
}

RecipeDetails.propTypes = {
  recipe: PropTypes.object
}

export default RecipeDetails;