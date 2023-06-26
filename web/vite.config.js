import { resolve } from "path";
import { defineConfig } from "vite";
import { visualizer } from "rollup-plugin-visualizer";
// import { createHtmlPlugin } from "vite-plugin-html";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  root: "src",
  base: "",
  define: {
    __VUE_OPTIONS_API__: true,
    __VUE_PROD_DEVTOOLS__: false,
  },
  build: {
    outDir: resolve(__dirname, "../Shifu/web"),
    chunkSizeWarningLimit: 2500,
    // emptyOutDir: true,
    // minify: false,
    rollupOptions: {
      input: {
        main: "src/index.html",
        // NativeHook: "src/native/NativeHook.js",
        // PostNativeHook: "src/native/PostNativeHook.js",
      },
      output: {
        entryFileNames: ({ name }) => {
          return "[name].js";
        },
        chunkFileNames: ({ name, exports }) => {
          if (exports.includes("gsap")) {
            return "chunks/gsap.js";
          }
          return "chunks/[name].js";
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
        this.addWatchFile(resolve(__dirname, "public/test.html"));
        this.addWatchFile(resolve(__dirname, "public/PostNativeHook.js"));
        this.addWatchFile(resolve(__dirname, "public/NativeHook.js"));
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
