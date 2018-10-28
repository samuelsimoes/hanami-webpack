var path = require("path"),
    ManifestPlugin = require("webpack-manifest-plugin");

var devServerPort = process.env.WEBPACK_DEV_SERVER_PORT,
    devServerHost = process.env.WEBPACK_DEV_SERVER_HOST,
    publicPath = process.env.WEBPACK_PUBLIC_PATH;

var config = {
  entry: {},

  output: {
    path: path.join(__dirname, "public" + publicPath),
    filename: "[name]-[chunkhash].js"
  },

  resolve: {
    root: path.join(__dirname, "apps")
  },

  plugins: [
    new ManifestPlugin({
      fileName: 'webpack_manifest.json'
    })
  ]
};

if (process.env.INBUILT_WEBPACK_DEV_SERVER) {
  config.devServer = {
    port: devServerPort,
    headers: { "Access-Control-Allow-Origin": "*" }
  };
}

module.exports = config;
