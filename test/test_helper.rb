ENV['WEBPACK_DEV_SERVER']      = 'true'
ENV['WEBPACK_DEV_SERVER_HOST'] = 'test.host'
ENV['WEBPACK_DEV_SERVER_PORT'] = '54321'

require "test/unit"
require "pry"
require "hanami-webpack"
