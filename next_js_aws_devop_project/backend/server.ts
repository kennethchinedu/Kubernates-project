import createServer_ from "./src/utils/server";

const PORT = process.env.PORT || 8080;

export const app = createServer_();

app.listen(PORT, () => {
  console.log(`Sever is running on port ${PORT}: http://localhost:${PORT}`);
});
