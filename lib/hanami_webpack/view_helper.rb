require 'hanami/utils/blank'
require_relative 'manifest'

module HanamiWebpack
  module ViewHelper
    def webpack_asset_path(bundle_name)
      raw(Hanami::Utils::Blank.blank?(bundle_name) ? '' : HanamiWebpack::Manifest.bundle_uri(bundle_name))
    end
  end
end
