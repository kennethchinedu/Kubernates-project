import { z as zod } from "zod";

const ingredientSchema = zod.object({
  name: zod.string(),
  amount: zod.string(),
});

export const createUpdateSchema = zod
  .object({
    title: zod.string().min(3),
    ingredients: zod.array(ingredientSchema).nonempty({
      message: "empty!",
    }),
    instructions: zod.string().min(20),
    image: zod.string(),
  })
  .required();

export const patchSchema = zod.object({
  title: zod.string().min(3).optional(),
  ingredients: zod.array(ingredientSchema).optional(),
  instructions: zod.string().min(20).optional(),
  image: zod.string().optional(),
});
