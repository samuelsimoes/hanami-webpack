require 'hanami/utils/blank'

module HanamiWebpack
  class Config
    class << self
      def public_path
        ENV['WEBPACK_PUBLIC_PATH']
      end

      def manifest_file
        ENV['WEBPACK_MANIFEST_FILE']
      end

      def dev_server_host
        ENV['WEBPACK_DEV_SERVER_HOST']
      end

      def dev_server_port
        ENV['WEBPACK_DEV_SERVER_PORT']
      end

      def inbuilt_dev_server?
        ENV['INBUILT_WEBPACK_DEV_SERVER'] == 'true'
      end

      def using_dev_server?
        if Hanami::Utils::Blank.blank?(ENV['WEBPACK_DEV_SERVER'])
          ENV['RACK_ENV'] != 'production'
        else
          ENV['WEBPACK_DEV_SERVER'] == 'true'
        end
      end
    end
  end
end
