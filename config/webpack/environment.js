const { environment } = require("@rails/webpacker");
const webpack = require("webpack");

environment.splitChunks();

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    jQuery: "jquery",
    Popper: ["popper.js", "default"]
  })
);

module.exports = environment;
