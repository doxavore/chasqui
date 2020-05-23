const { environment } = require("@rails/webpacker");
const webpack = require("webpack");
const miniSvgDataUri = require('mini-svg-data-uri');

const SVG_FILE_TEST = /\.svg$/i;
const URL_LOADER_TEST = /\.(?:svg|png|gif|jpe?g)$/i;

// TODO(aleks): Haven't been able to make this work in AA views
// environment.loaders.prepend(
//   "url",
//   {
//     test: URL_LOADER_TEST,
//     use: [{
//       loader: "url-loader",
//       options: {
//         limit: 4096,
//         name: "[name]-[hash].[ext]",
//         generator: (content, mimeType, encoding, resourcePath) => {
//           if (SVG_FILE_TEST.test(resourcePath)) {
//             return miniSvgDataUri(content.toString());
//           }

//           // Fallback to the default.
//           // See https://github.com/webpack-contrib/url-loader/.
//           return `data:${mimetype}${encoding ? `;${encoding}` : ''},${content.toString(
//             encoding || undefined
//           )}`;
//         },
//       },
//     }],
//   },
// );

// Avoid using both file and url loaders together.
// environment.loaders.get('file').exclude = URL_LOADER_TEST;

// resolve-url-loader must be used before sass-loader.
// See https://github.com/rails/webpacker/blob/master/docs/css.md#resolve-url-loader.
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: "resolve-url-loader",
});

// TODO(dtm): This is incompatible with ActiveAdmin. Its javascripts do not fully load.
// environment.splitChunks();

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    select2: "select2",
    Popper: ["popper.js", "default"],
  }),
);

module.exports = environment;
