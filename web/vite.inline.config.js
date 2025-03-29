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
		outDir: resolve(__dirname, "../Shifu/web"),
		assetsInlineLimit: 100000000, // 设置一个较大的值,确保所有资源都会被内联
		cssCodeSplit: false, // 禁用 CSS 代码分割
		emptyOutDir: true,
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
			}
		},
		{
			name: 'vite-plugin-assets-inline',
			transformIndexHtml: {
				enforce: 'pre',
				transform(html) {
					// 处理外部script为内联script
					html = html.replace(
						/<script src="\.\/native\/NativeHook\.js"><\/script>/,
						`<script>
							// NativeHook.js的内容会在构建时被内联到这里
						</script>`
					);

					// 处理favicon
					const faviconPath = resolve(__dirname, 'src/style/favicon.ico');
					const faviconContent = fs.readFileSync(faviconPath);
					const faviconBase64 = faviconContent.toString('base64');
					
					html = html.replace(
						/<link rel="icon" href="\/style\/favicon\.ico" \/>/,
						`<link rel="icon" href="data:image/x-icon;base64,${faviconBase64}">`
					);

					return html;
				}
			}
		},
		viteSingleFile(),
	],
	resolve: {
		alias: {
			vue: "vue/dist/vue.esm-bundler.js",
		},
	},
}); 