import { describe, it } from "@jest/globals";
import { JsonArray } from "@prisma/client/runtime/library";
import supertest from "supertest";
import { prismaMock } from "../singleton";
import createServer from "../utils/server";

const recipeData = (id: number) => ({
  id: id,
  title: "some recipe",
  slug: "some-recipe",
  instructions: "one or two pluto menia em",
  image: "image-gafuck.jpeg",
  ingredients: [{ name: "2by2", amount: "1 spoon of salt" }] as JsonArray,
  username: "joi",
  dateCreated: new Date(),
});

describe("recipe", () => {
  describe("get recipes", () => {
    it("get a list of all recipes", async () => {
      prismaMock.recipe.findMany.mockResolvedValue(
        new Array(100).fill(undefined).map((_, index) => recipeData(index + 1))
      );
      prismaMock.recipe.count.mockResolvedValue(100);

      const resp = await supertest(createServer())
        .get("/api/v1/recipes/")
        .expect(200);

      expect(prismaMock.recipe.findMany).toHaveBeenCalled();
    });

    it("assert that respone is paginated", async () => {
      prismaMock.recipe.findMany.mockResolvedValue(
        new Array(100).fill(undefined).map((_, index) => recipeData(index + 1))
      );
      prismaMock.recipe.count.mockResolvedValue(100);

      const resp = await supertest(createServer())
        .get("/api/v1/recipes/?page=2")
        .expect(200);

      expect(prismaMock.recipe.findMany).toHaveBeenCalled();
      expect(resp.body.data.totalPages).toBe(10);
      expect(resp.body.data.currentPage).toBe(2);
    });

    it("get a single recipe", async () => {
      prismaMock.recipe.findFirst.mockResolvedValue(recipeData(1));
      const resp = await supertest(createServer())
        .get("/api/v1/recipes/1")
        .expect(200);
      expect(resp.body.data.id).toBe(1);
    });
  });

  describe("create recipe", () => {
    it("test recipe creation", async () => {
      const data = {
        title: "some recipe",
        slug: "some-recipe",
        instructions: "one or two pluto menia em",
        image: "image-gafuck.jpeg",
        ingredients: [{ name: "2by2", amount: "1 spoon of salt" }] as JsonArray,
        username: "joi",
      };
      prismaMock.recipe.create.mockResolvedValue({
        ...data,
        id: 1,
        dateCreated: new Date(),
      });

      const resp = await supertest(createServer())
        .post("/api/v1/recipes")
        .send(data)
        .expect(201);

      expect(resp.body.data.slug).toEqual(data.slug);
    });

    it("test recipe fields are required from error message", async () => {
      const data = {};
      prismaMock.recipe.create.mockResolvedValue(recipeData(1));

      const resp = await supertest(createServer())
        .post("/api/v1/recipes")
        .send(data)
        .expect(400);
      expect(Array.from(Object.keys(resp.body.message))).toContain(
        "ingredients"
      );
    });
  });

  describe("update recipe", () => {
    it("test recipe patch", async () => {
      const data = {
        title: "vile recipe",
      };
      prismaMock.recipe.findFirst.mockResolvedValue(recipeData(1));
      prismaMock.recipe.update.mockResolvedValue({
        ...recipeData(1),
        title: "vile recipe",
      });
      const resp = await supertest(createServer())
        .patch("/api/v1/recipes/1")
        .send(data)
        .expect(200);

      expect(resp.body.data.title).toEqual(data.title);
    });
  });

  describe("test destroy", () => {
    it("test successful deletion of recipe", async () => {
      prismaMock.recipe.findFirst.mockResolvedValue(recipeData(1));
      await supertest(createServer()).delete("/api/v1/recipes/1").expect(204);
    });
  });
});
