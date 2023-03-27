import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
  root: "src",
  base: "",
  define: {
    "process.env": {
      NODE_ENV: JSON.stringify(process.env.NODE_ENV),
    },
  },
  build: {
    outDir: resolve(__dirname, "./public"),
    chunkSizeWarningLimit: 2500,
    lib: {
      entry: "native/NativeHook.js",
      name: "NativeHook",
      fileName: (format) => `NativeHook.js`,
      formats: ["umd"],
    },
  },
  plugins: [],
});
