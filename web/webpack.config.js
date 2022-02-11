const path = require("path");
const webpack = require("webpack");
const CopyWebpackPlugin = require("copy-webpack-plugin");

console.log(process.env.NODE_ENV);
module.exports = (env = {}, { mode = "production" }) => {
  const isProd = mode === "production";
  const srcPath = path.resolve(__dirname, "./src");
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
              ignore: ["**/main.js", "**/.DS_Store", "index.js"],
            },
          },
        ],
      })
    );
  }

  if (process.env.NODE_ENV == "copy") {
    console.log("is copy ", plugins);
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
  }
  return {
    entry: {
      main: "./src/main.js",
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
