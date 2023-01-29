import { resolve } from "path";
import { defineConfig } from "vite";
import { visualizer } from "rollup-plugin-visualizer";
import vue from "@vitejs/plugin-vue";
console.log(visualizer)
let build = {
  page: {
    outDir: resolve(__dirname, "dist"),
    chunkSizeWarningLimit: 2500,
    emptyOutDir: true,
    sourcemap: true,
    rollupOptions: {
      output: {
        entryFileNames: "[name].js",
        chunkFileNames: "js/[name].js",
        assetFileNames: "assets/[name].[ext]",
      },
    },
  },
};

export default defineConfig({
  root: "src",
  base: "",
  build: {
    outDir: resolve(__dirname, "../Shifu/web"),
    chunkSizeWarningLimit: 2500,
    emptyOutDir: true,
    // sourcemap: true,
    rollupOptions: {
      output: {
        entryFileNames: "main.js",
        chunkFileNames: "js/[name].js",
        assetFileNames: "assets/[name].[ext]",
      },
    },
  },
  plugins: [
    vue(),
    // visualizer({
    //   open: true,
    //   gzipSize: true,
    //   brotliSize: true,
    // }),
    {
      name: "watch-external",
      buildStart() {
        this.addWatchFile(resolve(__dirname, "public/PostNativeHook.js"));
      },
    },
  ],
  resolve: {
    alias: {
      vue: "vue/dist/vue.esm-bundler.js",
    },
  },
  publicDir: resolve(__dirname, "./public"),
});
