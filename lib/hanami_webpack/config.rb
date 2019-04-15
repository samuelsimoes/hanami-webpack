require 'hanami/utils/blank'
require 'memoizable'

module HanamiWebpack
  class Config
    include Memoizable

    class << self
      extend Forwardable

      def config
        @config ||= new(env: ENV)
      end

      def_delegators :config,
                     :dev_server_host,
                     :dev_server_port,
                     :inbuilt_dev_server?,
                     :manifest_file,
                     :public_path,
                     :using_dev_server?
    end

    attr_reader :env

    def initialize(env:)
      @env = env
    end

    def dev_server_host
      env['WEBPACK_DEV_SERVER_HOST']
    end
    memoize :dev_server_host

    def dev_server_port
      env['WEBPACK_DEV_SERVER_PORT']
    end
    memoize :dev_server_port

    def inbuilt_dev_server?
      env['INBUILT_WEBPACK_DEV_SERVER'] == 'true'
    end
    memoize :inbuilt_dev_server?

    def manifest_file
      env['WEBPACK_MANIFEST_FILE']
    end
    memoize :manifest_file

    def public_path
      env['WEBPACK_PUBLIC_PATH']
    end
    memoize :public_path

    def using_dev_server?
      if Hanami::Utils::Blank.blank?(env['WEBPACK_DEV_SERVER'])
        env['RACK_ENV'] != 'production'
      else
        env['WEBPACK_DEV_SERVER'] == 'true'
      end
    end
    memoize :using_dev_server?
  end
end
