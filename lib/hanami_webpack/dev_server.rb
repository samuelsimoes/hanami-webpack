require_relative 'config'

module HanamiWebpack
  module DevServer
    def start
      if HanamiWebpack::Config.using_dev_server? && HanamiWebpack::Config.inbuilt_dev_server?
        command_options = ENV['WEBPACK_DEV_SERVER_CMD_OPTIONS']

        if Hanami::Utils::Blank.blank?(command_options)
          command_options = Shellwords.escape(command_options)
        end

        command = "./node_modules/.bin/webpack-dev-server #{command_options}"

        spawn(command.strip)
      end
      super
    end
  end
end
