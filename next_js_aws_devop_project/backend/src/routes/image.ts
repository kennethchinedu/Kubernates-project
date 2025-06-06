import express from "express";
import multer from "multer";
import path, { dirname } from "path";
import { upload } from "../controller/imageController";

const imageRouter = express.Router();

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(dirname(dirname(__dirname)), "/public/images"));
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix + "-" + file.originalname);
  },
});

const upload_ = multer({ storage: storage });

imageRouter.post("/", upload_.single("image"), upload);

export default imageRouter;
