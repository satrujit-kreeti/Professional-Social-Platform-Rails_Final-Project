const { environment } = require('@rails/webpacker');
const babelLoader = require('./loaders/babel');

environment.loaders.append('babel', babelLoader);

environment.config.delete('node');

environment.config.set('node', {
  global: true,
  __dirname: true,
  __filename: true,
});

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment;
