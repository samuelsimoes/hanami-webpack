# hanami-webpack

:warning: **This is a very experimental version, but it works, so, be aware!**

This plugin will help you to use [Webpack](webpack.github.io) as your asset pipeline for Hanami with [webpack-dev-server](http://webpack.github.io/docs/webpack-dev-server.html)  for development.

It'll work without any problem with your existent assets using the [hanami/assets](https://github.com/hanami/assets).

## Setup

I'll assume that you already have the Node.js installed.

1. Add the `gem 'hanami-webpack', github: 'samuelsimoes/hanami-webpack'` on your Gemfile.
2. Run `bundle install`.
3. Copy the base Webpack config **[webpack.config.sample.js](./webpack.config.sample.js)** and **[package.sample.json](./package.sample.json)** on your app root (removing the `.sample` in the name).
4. Run `npm install`.
5. Run `bundle exec hanami serve` and profite.

## Usage

On development, this plugin will try to start the **[webpack-dev-server](http://webpack.github.io/docs/webpack-dev-server.html)** with your Hanami server. You can disable this behavior (see [configuration section](#configuration)).

You will need use the `webpack_asset_path` helper on your templates to get the correct bundle path.

Let's say that you have a [bundle](http://webpack.github.io/docs/configuration.html#entry) with the name `web.people`. You should place on your template:

```erb
<script src="<%= webpack_asset_path('web.people') %>"></script>
```

To make a build just run `./node_modules/.bin/webpack` on the project root.

## Configuration

All plugin configuration is done by the following ENV vars:

| Name | Default Value | Description |
| --- | --- | --- |
| `WEBPACK_DEV_SERVER_HOST` | `localhost` | The host where your asset dev server is running. |
| `WEBPACK_DEV_SERVER_PORT` | `3020` | The port where your asset dev server is running. |
| `WEBPACK_PUBLIC_PATH` | `/` | Whenever you want use other [publicPath](http://webpack.github.io/docs/configuration.html#output-publicpath) you should update this var. |
| `INBUILT_WEBPACK_DEV_SERVER` | `true` | If you want start the webpack-dev-server when you start your hanami server (except on production). |
| `WEBPACK_DEV_SERVER` | `false` on production `true` in any other env. | If you want disable the webpack-dev-server integration set this as `false`. |
| `WEBPACK_MANIFEST_FILE` | `webpack_manifest.json` | The name of the manifest file that exposes the assets path to Hanami. |

## With Heroku
Just run the command below to configure your Heroku app. This command will set your Hanami app to serve the assets (you probably already done this) and will set the Ruby and Node.js buildpacks.

```
heroku config:set SERVE_STATIC_ASSETS=true && heroku buildpacks:set --index 1 heroku/nodejs && heroku buildpacks:set --index 2 heroku/ruby
```

To build your assets when you deploy, you will need place on your `package.json` the [Heroku auto-commands](https://devcenter.heroku.com/articles/nodejs-support#heroku-specific-build-steps):

```
{
  ...
  "scripts": {
    "build": "webpack",
    "heroku-postbuild": "npm run build"
  }
}
```

## Todo

* Write tests.
* Release on RubyGems.
* Research a better way to do these things without monkey patches (I have done, but looks like that with the current Hanami version it's impossible).

----------
Samuel Simões ~ [@samuelsimoes](https://twitter.com/samuelsimoes) ~ [Blog](http://blog.samuelsimoes.com/)
