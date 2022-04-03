import React, { useState } from 'react'
import axios from 'axios';

export default function App(props) {
  const [ingredients, setIngredients] = useState('')
  const [recipes, setRecipes] = useState([])
  const [activeRecipe, setActiveRecipe] = useState(null)

  const sendIngredientsHandler = (e) => {
    e.preventDefault()

    return axios({
      method: 'post',
      url: '/home/recipes-for-ingredients',
      data: {
        ingredients: ingredients
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    }).then((response) => {
      if (response.status === 200) {
        console.log('SUCCESS', response.data)
        setRecipes(response.data.recipes)
      } else {
        console.log('ERROR', response.data)
      }
    })
  }

  const revealRecipeDetails = (recipe) => {
    setActiveRecipe(recipe)
  }

  return (
    <>
      <div class="flex flex-wrap -mx-3 mb-6">
        <div class="w-full px-3">
          <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" for="fridge-contents">
            What do you have in your fridge?
          </label>
          <input id="fridge-contents"
                 onChange={evt => setIngredients(evt.target.value)}
                 value={ingredients}
                 class="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="input fridge contents"
          />
          <p class="text-gray-600 text-xs italic">separate ingredients with comma</p>
        </div>
      </div>

      <div class="flex flex-wrap -mx-3 mb-6">
        <span class="bg-pink-100 text-pink-800 text-md font-medium mr-2 px-2 py-1 rounded dark:bg-pink-200 dark:text-pink-900">Pink</span>
      </div>

      <button type="button"
              onClick={evt => sendIngredientsHandler(evt)}
              class="w-full text-white bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-2 mb-2"
              >
          Find recipes containing these ingredients
      </button>

      <div class="flex flex-wrap -mx-3 mb-6">

        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                <tr>
                    <th scope="col" class="px-6 py-3">
                        Recipe
                    </th>
                    <th scope="col" class="px-6 py-3">
                        Rating
                    </th>
                </tr>
            </thead>
            <tbody>
                {/* <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
                    <th scope="row" class="px-6 py-4 font-medium text-gray-900 dark:text-white whitespace-nowrap">
                        Creme brulee
                    </th>
                    <td class="px-6 py-4">
                        3.0
                    </td>
                </tr>
                <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
                <th scope="row" class="px-6 py-4 font-medium text-gray-900 dark:text-white whitespace-nowrap">
                        Suflet
                    </th>
                    <td class="px-6 py-4">
                        4.0
                    </td>
                </tr> */}
                {recipes.map(recipe => {
                  return (
                    <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                      onClick={() => revealRecipeDetails(recipe) }
                    >
                      <th scope="row" class="px-6 py-4 font-medium text-gray-900 dark:text-white whitespace-nowrap">
                          {recipe.name}
                      </th>
                      <td class="px-6 py-4">
                        {recipe.rating}
                      </td>
                    </tr>
                  )
                })}
            </tbody>
        </table>
      </div>

      { activeRecipe && (
        <div class="flex flex-wrap -mx-3 mb-6">
          <div class="w-full px-3">
            {JSON.stringify(activeRecipe)}
          </div>
        </div>
      )}

  </>
  )
}