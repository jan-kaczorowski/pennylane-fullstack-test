import PropTypes from 'prop-types'
import React from 'react'

const RecipeList = props => (
  <>
    <div class="flex flex-wrap -mx-3 mb-6">
      <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                  <th scope="col" class="px-6 py-3">
                      Recipe
                  </th>
                  <th scope="col" class="px-6 py-3">
                      Relevance
                  </th>
                  <th scope="col" class="px-6 py-3">
                      Rating
                  </th>
              </tr>
          </thead>
          <tbody>
              {props.recipes.map(recipe => {
                return (
                  <tr key={recipe.id} 
                      class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-blue-600 hover:text-white"
                      onClick={() => props.rowClickHandler(recipe) }
                  >
                    <th scope="row" class="font-medium px-6">
                        {recipe.title}
                    </th>
                    <td class="px-6 py-4">
                      {recipe.relevance}%
                    </td>
                    <td class="px-6 py-4">
                      {recipe.ratings}
                    </td>
                  </tr>
                )
              })}
          </tbody>
      </table>
    </div>
  </>
)
RecipeList.defaultProps = {
  recipes: [],
  rowClickHandler: () => {}
}

RecipeList.propTypes = {
  recipes: PropTypes.array,
  rowClickHandler: PropTypes.func
}

export default RecipeList;