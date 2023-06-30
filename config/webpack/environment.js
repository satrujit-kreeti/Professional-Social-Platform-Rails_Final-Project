const { environment } = require('@rails/webpacker');
const babelLoader = require('./loaders/babel');

environment.loaders.append('babel', babelLoader);

environment.config.delete('node');

environment.config.set('node', {
  global: true,
  __dirname: true,
  __filename: true,
});

module.exports = environment;
