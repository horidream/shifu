import { resolve } from "path";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { viteSingleFile } from "vite-plugin-singlefile";
import fs from "fs"


export default defineConfig({
	root: "src",
	base: "",
	define: {
		__VUE_OPTIONS_API__: true,
		__VUE_PROD_DEVTOOLS__: false,
	},
	build: {
		outDir: resolve(__dirname, "../Shifu/web/inline"),
		assetsInlineLimit: 100000000, // 设置一个较大的值,确保所有资源都会被内联
		cssCodeSplit: false, // 禁用 CSS 代码分割
		emptyOutDir: false,
		rollupOptions: {
			input: resolve(__dirname, "src/index.html"),
			output: {
				inlineDynamicImports: true,
				manualChunks: undefined, // 禁用代码分割
				entryFileNames: "assets/[name].js",
				chunkFileNames: "assets/[name].js",
				assetFileNames: "assets/[name][extname]",
			},
		},
		target: "esnext",
		minify: true,
		sourcemap: false,
		assetsDir: "",
	},
	plugins: [
		vue(),
		{
			name: "vite-plugin-preload-fix",
			renderChunk(code) {
				return code.replace(/__VITE_PRELOAD__/g, "void 0");
			},
		},
		{
			name: "vite-plugin-assets-inline",
			transformIndexHtml: {
				enforce: "pre",
				transform(html) {
					// 使用public目录下构建好的NativeHook.js
					const nativeHookPath = resolve(
						__dirname,
						"public/NativeHook.js"
					);
					const nativeHookContent = fs.readFileSync(
						nativeHookPath,
						"utf-8"
					);

					html = html.replace(
						/<script src="\/NativeHook\.js" type="module"><\/script>/,
						`<script type="module" nonce="nonce-aTdFb6j66d43oTcvXuDb5na">${nativeHookContent}</script>`
					);

					// 添加example.md的内容
					const examplePath = resolve(__dirname, "public/example.md");
					const exampleContent = fs.readFileSync(
						examplePath,
						"utf-8"
					);

					// 添加一个script标签来存储markdown内容
					html = html.replace(
						"</head>",
						`<script type="text/markdown" id="example-md" nonce="nonce-aTdFb6j66d43oTcvXuDb5na">${exampleContent}</script>\n</head>`
					);

					// 处理favicon
					const faviconPath = resolve(
						__dirname,
						"src/style/favicon.ico"
					);
					const faviconContent = fs.readFileSync(faviconPath);
					const faviconBase64 = faviconContent.toString("base64");

					html = html.replace(
						/<link rel="icon" href="\/style\/favicon\.ico" \/>/,
						`<link rel="icon" href="data:image/x-icon;base64,${faviconBase64}">`
					);
					return html;
				},
			},
		},
		viteSingleFile(),
	],
	resolve: {
		alias: {
			vue: "vue/dist/vue.esm-bundler.js",
		},
	},
}); 