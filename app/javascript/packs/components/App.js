import React, { useState } from 'react'
import axios from 'axios';
import RecipeList from './RecipeList';
import RecipeDetails from './RecipeDetails';

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

  return (
    <>
      <h2 class="text-5xl dark:text-white mb-6">Recipe finder</h2>
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

      <button type="button"
              onClick={evt => sendIngredientsHandler(evt)}
              class="w-full text-white bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-2 mb-2"
              >
          Find recipes containing these ingredients
      </button>

      {recipes.length > 0 && <RecipeList recipes={recipes} rowClickHandler={(recipe) => setActiveRecipe(recipe)} />}

      {activeRecipe && <RecipeDetails recipe={activeRecipe} />}
  </>
  )
}