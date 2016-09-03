require_relative 'config'

module HanamiWebpack
  module SecurityHeadersHijack
    def content_security_policy(*args)
      new_script_src_directive = "script-src 'self' 'unsafe-eval'"

      if HanamiWebpack::Config.using_dev_server?
        new_script_src_directive +=
          " http://#{HanamiWebpack::Config.dev_server_host}:#{HanamiWebpack::Config.dev_server_port}"
      end

      super(*args).gsub("script-src 'self'", new_script_src_directive)
    end
  end
end
