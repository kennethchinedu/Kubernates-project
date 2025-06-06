import { asyncHandler } from "../middleware/async";
import { Response } from "../utils/response";

// @desc handles image upload
// @route POST /image
export const upload = asyncHandler(async (req, res, next) => {
  return res.status(201).json(
    new Response("file uploaded", 201, {
      name: req.file?.filename,
    }).dump()
  );
});
