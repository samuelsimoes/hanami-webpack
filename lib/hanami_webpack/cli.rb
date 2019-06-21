require "thor"

module HanamiWebpack
  class CLI < Thor
    include Thor::Actions
    
    source_root File.expand_path("../templates", File.dirname(__FILE__))

    desc "setup", "Setup webpack and package.json"
      def webpack
        copy_file 'webpack.config.sample.js', './webpack.config.js'
        copy_file 'package.sample.json', './package.json'
      end
  end
end
