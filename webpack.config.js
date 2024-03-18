const path = require('path')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const webpack = require('webpack')

const dist = path.resolve(__dirname, 'www', 'js', 'postguard')
const webpackMode = 'development'

module.exports = {
    name: 'postguard',
    mode: webpackMode,
    entry: {
        string: './postguard/string.js',
        file: './postguard/file.js',
    },
    output: {
        path: dist,
        filename: '[name].js',
    },
    experiments: {
        asyncWebAssembly: true,
        topLevelAwait: true,
    },
    // devServer: {
    //     compress: true,
    //     port: 9000,
    // },
    resolve: {
        fallback: {
            https: require.resolve('https-browserify'),
            http: require.resolve('stream-http'),
            url: require.resolve('url/'),
            util: require.resolve('util/'),
            events: false,
        },
        modules: [path.resolve(__dirname, 'node_modules')],
    },
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: ['style-loader', 'css-loader'],
            },
        ],
    },
    plugins: [
        new webpack.ProvidePlugin({
            process: 'process/browser',
        }),
        new CleanWebpackPlugin(),
    ],
}
