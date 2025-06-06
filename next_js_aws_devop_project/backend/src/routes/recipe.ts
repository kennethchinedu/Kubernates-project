import express from "express";
import {
  createRecipe,
  deleteRecipe,
  getRecipe,
  getRecipes,
  updateRecipe,
} from "../controller/recipeController";
import validate from "../middleware/validationMiddleware";
import { createUpdateSchema, patchSchema } from "../schema/recipeSchema";

const router = express.Router();

router.get("/", getRecipes);

router.get("/:id", getRecipe);

router.post("/", validate(createUpdateSchema), createRecipe);

router.put("/:id", validate(createUpdateSchema), updateRecipe);

router.patch("/:id", validate(patchSchema), updateRecipe);

router.delete("/:id", deleteRecipe);

router.post("/upload-image");

export default router;
