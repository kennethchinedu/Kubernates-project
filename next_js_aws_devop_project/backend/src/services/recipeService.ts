import { Prisma } from "@prisma/client";
import { NextFunction } from "express";
import { HTTP_STATUS_CODE } from "../../constants";
import prisma from "../lib/prisma";
import { recipeType } from "../types/recipe.type";
import { ErrorResponse } from "../utils/errorResponse";
import { PaginatedResponse } from "../utils/paginatedResponse";

export default class RecipeService {
  private static instance: RecipeService | undefined;

  private constructor() {
    // singleton implementation
  }

  public async getRecipes(
    page: number,
    _next: NextFunction
  ): Promise<{ totalItems: number; recipes: any[] } | void> {
    try {
      const page_ = page || 1;
      const recipes = await Promise.all([
        prisma.recipe.count(),
        prisma.recipe.findMany({
          ...PaginatedResponse.getPaginationProps(page_),
          orderBy: {
            dateCreated: "desc",
          },
        }),
      ]);

      return { totalItems: recipes[0], recipes: recipes[1] };
    } catch (err) {
      return _next(err);
    }
  }

  public async getRecipe(
    id: number,
    _next: NextFunction
  ): Promise<Record<string, any> | void> {
    try {
      const recipe = await prisma.recipe.findFirst({
        where: {
          id,
        },
      });

      if (!recipe) {
        return _next(
          new ErrorResponse("recipe not found", HTTP_STATUS_CODE[404].code)
        );
      }

      return recipe;
    } catch (err) {
      return _next(err);
    }
  }

  public async createRecipe(
    body: recipeType,
    _next: NextFunction
  ): Promise<any> {
    try {
      const recipe = await prisma.recipe.create({
        data: {
          ...body,
          slug: this.slugify(body.title),
        },
      });

      return recipe;
    } catch (err) {
      return _next(err);
    }
  }

  public async updateRecipe(
    body: Partial<recipeType>,
    id: number,
    _next: NextFunction
  ): Promise<any> {
    try {
      const recipe = await prisma.recipe.findFirst({
        where: {
          id,
        },
      });

      if (!recipe) {
        return _next(
          new ErrorResponse("recipe not found", HTTP_STATUS_CODE[404].code)
        );
      }

      const updateRecipe = await prisma.recipe.update({
        where: {
          id,
        },
        data: {
          title: body?.title ?? recipe.title,
          ingredients:
            (body?.ingredients as Prisma.JsonArray) ?? recipe.ingredients,
          instructions: body?.instructions ?? recipe.instructions,
          image: body?.image ?? recipe.image,
          username: body?.username ?? recipe.username,
        },
      });

      return updateRecipe;
    } catch (err) {
      return _next(err);
    }
  }

  public async deleteRecipe(
    id: number,
    _next: NextFunction
  ): Promise<boolean | void> {
    try {
      await prisma.recipe.delete({
        where: {
          id,
        },
      });

      return true;
    } catch (err) {
      return _next(err);
    }
  }

  public static getInstance(): RecipeService {
    // singleton implementation
    if (this.instance) {
      return this.instance;
    }
    this.instance = new RecipeService();

    return this.instance;
  }

  private slugify(value: string) {
    return value.split(" ").join("-");
  }
}
