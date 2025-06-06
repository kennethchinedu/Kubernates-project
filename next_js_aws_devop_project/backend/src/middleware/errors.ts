import { NextFunction } from "express";
import { ErrorResponse } from "../utils/errorResponse";

//@desc handles all errors
const errorHandler = (
  err: any,
  req: Request | any,
  res: Response | any,
  next: NextFunction | any
) => {
  let error = new ErrorResponse(err.message, err.statusCode || 500);

  // PrismaClientInitializationError
  if (err.name === "PrismaClientInitializationError") {
    const message = "Prisma connection failed";
    error = new ErrorResponse(message, 500);
  }

  // PrismaClientKnownRequestError
  if (err.name === "PrismaClientKnownRequestError") {
    const message = "An errror occured. check payload";
    error = new ErrorResponse(message, 400);
  }

  // PrismaClientValidationError
  if (err.name === "PrismaClientValidationError") {
    console.log(err);
    const message = "Bad request, check submitted data";
    error = new ErrorResponse(message, 400);
  }

  res.status(error.statusCode || 500).json(error.dump());
};

export default errorHandler;
