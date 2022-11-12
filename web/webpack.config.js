const path = require("path");
const webpack = require("webpack");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const SoundsPlugin = require("sounds-webpack-plugin");

console.log(process.env.NODE_ENV);
module.exports = (env = {}, { mode = "production" }) => {
  const isProd = mode === "production";
  const srcPath = path.resolve(__dirname, "./src");
  const publicPath = path.resolve(__dirname, "./public");
  const outputPath = path.resolve(__dirname, "../Shifu/web");
  const devtool =
    process.env.NODE_ENV === "production" ? false : "eval-source-map";
  const plugins = [
    new webpack.DefinePlugin({
      // "process.env": {
      //   NODE_ENV: JSON.stringify(process.env.NODE_ENV),
      // },
      __VUE_OPTIONS_API__: true,
      __VUE_PROD_DEVTOOLS__: false,
    }),
  ];
  if (isProd) {
    plugins.push(
      new CopyWebpackPlugin({
        patterns: [
          {
            from: srcPath,
            to: outputPath,
            globOptions: {
              ignore: [
                "**/*.js",
                "**/.DS_Store",
                "node_modules/**",
                "**/*.LICENSE.txt",
              ],
            },
          },
          {
            from: publicPath,
            to: outputPath,
          }
        ],
      })
    );
  }

  if (process.env.NODE_ENV == "dev") {
    return {
      entry: {
        empty: "./src/empty.js",
      },
      output: {
        path: outputPath,
        filename: "[name].js",
      },
      target: "web",
      resolve: {
        alias: {
          vue$: "vue/dist/vue.esm-bundler.js",
        },
        extensions: ["*", ".ts", ".js", ".vue", ".json"],
      },
      plugins,
    };
  } else {
    plugins.push(
      new SoundsPlugin({
        sounds: {
          success: path.join(__dirname, "tools/success.mp3"),
        },
        notifications: {
          // invalid is a webpack hook
          // you can check all hooks at https://github.com/webpack/webpack/blob/master/lib/Compiler.js#L32
          // 'customSound' is the key provided in sounds
          invalid: "customSound",
          // you can provide a function to customize it further
          done() {
            this.play("success");
          },
        },
      })
    );
  }
  return {
    entry: {
      main: "./src/main.js",
      to_markdown: "./src/to_markdown.js",
    },
    output: {
      path: outputPath,
      filename: "[name].js",
    },
    devtool,
    target: "web",
    module: {
      rules: [
        {
          test: /\.js$/,
          loader: "babel-loader",
          exclude: /(node_modules|src\/vendor)/,
        },
      ],
    },
    resolve: {
      alias: {
        vue$: "vue/dist/vue.esm-bundler.js",
      },
      extensions: ["*", ".ts", ".js", ".vue", ".json"],
    },
    performance: {
      hints: false,
    },
    optimization: {
      minimize: process.env.NODE_ENV == "production",
    },
    devServer: {
      historyApiFallback: true,
      hot: true,
      port: 5555,
      open: ["/index.html"],
      static: [path.resolve(__dirname, "./src")],
      client: {
        overlay: true,
        progress: true,
        logging: "none",
      }
    },
    plugins,
  };
};
