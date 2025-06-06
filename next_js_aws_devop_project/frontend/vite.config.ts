// import react from "@vitejs/plugin-react";
// import path from "path";
// import { defineConfig } from "vite";

// // https://vitejs.dev/config/
// export default defineConfig({
//   plugins: [react()],
//   base: "./",
//   resolve: {
//     alias: {
//       "@": path.resolve(__dirname, "./src"),
//     },
//   },
// });


import react from "@vitejs/plugin-react";
import path from "path";
import { defineConfig } from "vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: "./",
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: {
    host: "0.0.0.0", // Bind to all network interfaces
    port: 5173, // Ensure it's using the correct port
    strictPort: true, // Fail if port is already in use
    hmr: {
      port: 5173, // Use the same port for HMR (Hot Module Replacement)
    },
  },
});
