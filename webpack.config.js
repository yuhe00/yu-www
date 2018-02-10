const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: {
    app: [
      './src'
    ]
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].bundle.js',
    publicPath: '/'
  },

  module: {
    rules: [{
      test: /\.js$/,
      use: [
        'babel-loader'
      ]
    }, {
      test: /\.elm$/,
      exclude: /\/(node_modules|elm-stuff)/,
      use: [
        process.env.NODE_ENV === 'production' ?
        'elm-webpack-loader' :
        'elm-webpack-loader?verbose=true&warn=true&debug=true'
      ]
    }, {
      test: /.css$/,
      use: [
        'style-loader',
        'css-loader'
      ]
    }]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.html',
      inject: 'body',
      filename: 'index.html'
    }),
    new CopyWebpackPlugin([{
      from: './public',
      to: './'
    }])
  ],

  devServer: {
    contentBase: 'public',
    historyApiFallback: true
  }
};
