// @desc Get all recipes

import { asyncHandler } from "../middleware/async";
import RecipeService from "../services/recipeService";
import { ErrorResponse } from "../utils/errorResponse";
import { PaginatedResponse } from "../utils/paginatedResponse";
import { Response } from "../utils/response";

const recipeService = RecipeService.getInstance();
// @desc fetch all recipes
// @route GET /api/v1/recipes
export const getRecipes = asyncHandler(async (req, res, next) => {
  let page_ = 1;

  const { page } = req.query;
  if (page && !isNaN(page as any)) page_ = +page;

  const resp = await recipeService.getRecipes(page_, next);

  if (resp) {
    const { recipes, totalItems } = resp;
    return res
      .status(200)
      .json(
        new PaginatedResponse(
          "all recipies",
          200,
          totalItems,
          page_,
          recipes
        ).dump()
      );
  }

  return resp;
});

// @desc Get a single recipes
// @route GET /api/v1/recipes/:id
export const getRecipe = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  if (isNaN(id as any))
    return next(new ErrorResponse("id must be a number", 400));

  const resp = await recipeService.getRecipe(+id, next);

  if (resp) {
    return res
      .status(200)
      .json(new Response("recipe detail", 200, resp).dump());
  }

  return resp;
});

// @desc create a recipe
// @route POST /api/v1/recipes
export const createRecipe = asyncHandler(async (req, res, next) => {
  const resp = await recipeService.createRecipe(req.body, next);

  if (!resp) return resp;

  return res.status(201).json(new Response("recipe created", 201, resp).dump());
});
// @desc Update a single recipe
// @route PUT|PATCH /api/v1/recipes/:id
export const updateRecipe = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  if (isNaN(id as any))
    return next(new ErrorResponse("id must be a number", 400));

  const resp = await recipeService.updateRecipe(req.body, +id, next);

  if (resp) {
    return res
      .status(200)
      .json(new Response("recipe detail", 200, resp).dump());
  }

  return resp;
});

// @desc Delete a single recipes
// @route DELETE /api/v1/recipes/:id
export const deleteRecipe = asyncHandler(async (req, res, next) => {
  const { id } = req.params;

  if (isNaN(id as any))
    return next(new ErrorResponse("id must be a number", 400));

  const resp = await recipeService.deleteRecipe(+id, next);
  console.log(resp);
  if (resp === true) return res.status(204).json({});
  return resp;
});
