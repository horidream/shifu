import { resolve } from "path";
import { defineConfig } from "vite";
import { visualizer } from "rollup-plugin-visualizer";
// import { createHtmlPlugin } from "vite-plugin-html";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  root: "src",
  base: "",
  build: {
    outDir: resolve(__dirname, "../Shifu/web"),
    chunkSizeWarningLimit: 2500,
    emptyOutDir: true,
    // assetsDir: 'assets',
    // sourcemap: true,
    rollupOptions: {
      input: {
        main: "src/index.html",
        NativeHook: "src/native/NativeHook.js",
        PostNativeHook: "src/native/PostNativeHook.js",
      },
      output: {
        entryFileNames: ({ name }) => {
          return "[name].js";
        },
        assetFileNames: ({ name }) => {
          return "assets/[name].[extname]";
        },
      },
    },
  },
  plugins: [
    vue(),
    // createHtmlPlugin({
    //   entry: "src/main.js",
    //   template: "src/index.html",
    //   inject: {
    //     data: {
    //       nativeHook: "./NativeHook.js",
    //     },
    //   },
    // }),
    // visualizer({
    //   open: true,
    //   gzipSize: true,
    //   brotliSize: true,
    // }),
    {
      name: "watch-external",
      buildStart() {
        // this.addWatchFile(resolve(__dirname, "public/PostNativeHook.js"));
        // this.addWatchFile(resolve(__dirname, "public/NativeHook.js"));
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
