import { NextFunction, Request, Response } from "express";
import { AnyZodObject, ZodError } from "zod";
import { ErrorResponse } from "../utils/errorResponse";

const validate =
  (schema: AnyZodObject) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync(req.body);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const errors: Record<string, string> = {};
        error.issues.forEach((issue: any) => {
          errors[issue.path.join(".")] = `this field is ${issue.message}`;
        });
        res.status(400).json(new ErrorResponse(errors, 400).dump());
      } else {
        res.status(500).json(error);
      }
    }
  };

export default validate;
