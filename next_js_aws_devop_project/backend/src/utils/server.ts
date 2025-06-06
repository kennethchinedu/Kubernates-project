import cors from "cors";
import express from "express";
import path, { dirname } from "path";
import { createRouteHandler } from "uploadthing/express";
import { uploadRouter } from "../lib/uploadthing";
import errorHandler from "../middleware/errors";
import imageRouter from "../routes/image";
import recipe from "../routes/recipe";
import { ErrorResponse } from "./errorResponse";

export default function createServer() {
  const basePathV1 = "/api/v1";

  const app = express();

  app.use(cors({ origin: process.env.CLIENT_URL, credentials: true }));
  app.use(express.static(path.join(dirname(dirname(__dirname)), "public")));

  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));

  //ROUTES
  app.use(`${basePathV1}/recipes`, recipe);
  app.use(`/image`, imageRouter);
  app.use(
    "/api/uploadthing",
    createRouteHandler({
      router: uploadRouter,
      config: {
        // callbackUrl: "https://a310-197-211-59-54.ngrok-free.app/",
      },
    })
  );
  app.use((res, req, next) => {
    const error = new ErrorResponse("Not Found", 404);
    next(error);
  });

  //Error handler
  app.use(errorHandler);

  return app;
}
