require 'net/http'
require 'hanami/utils/blank'
require 'hanami/utils/path_prefix'
require_relative 'webpack_error'
require_relative 'entry_point_missing_error'

module HanamiWebpack
  class Manifest
    def self.bundle_uri(bundle_name)

      raise HanamiWebpack::WebpackError, manifest['errors'] unless Hanami::Utils::Blank.blank?(manifest['errors'])

      path = manifest['assetsByChunkName'][bundle_name]

      if Hanami::Utils::Blank.blank?(path)
        raise HanamiWebpack::EntryPointMissingError, "Can't find entry point '#{bundle_name}' in webpack manifest"
      end

      path = Hanami::Utils::PathPrefix.new('/').join(HanamiWebpack::Config.public_path).join(path).to_s

      if HanamiWebpack::Config.using_dev_server?
        path = "//#{HanamiWebpack::Config.dev_server_host}:#{HanamiWebpack::Config.dev_server_port}#{path}"
      end

      path
    end

    def self.manifest_path
      Hanami::Utils::PathPrefix.new('/').join(HanamiWebpack::Config.public_path).join(HanamiWebpack::Config.manifest_file)
    end

    def self.remote_manifest
      host = HanamiWebpack::Config.dev_server_host
      port = HanamiWebpack::Config.dev_server_port
      http = Net::HTTP.new(host, port)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.get(manifest_path).body
      JSON.parse(response)
    end

    def self.static_manifest
      @_manifest ||= begin
        path =
          Hanami
            .public_directory
            .join(*HanamiWebpack::Config.public_path.split('/'))
            .join(HanamiWebpack::Config.manifest_file)

        file = File.read(path)

        JSON.parse(file)
      end
    end

    def self.manifest
      HanamiWebpack::Config.using_dev_server? ? remote_manifest : static_manifest
    end
  end
end
