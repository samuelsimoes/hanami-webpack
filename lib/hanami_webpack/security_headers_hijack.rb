require_relative 'config'

module HanamiWebpack
  module SecurityHeadersHijack
    WEBPACK_HOST    = "#{Config.dev_server_host}:#{Config.dev_server_port}".freeze
    DEFAULT_PROC    = proc { |policy| "#{policy} http://#{WEBPACK_HOST}" }
    DIRECTIVE_PROCS = {
      "connect-src" => proc { |policy| "#{DEFAULT_PROC.call(policy)} ws://#{WEBPACK_HOST}" },
      "font-src"    => DEFAULT_PROC,
      "style-src"   => DEFAULT_PROC,
      "script-src"  => DEFAULT_PROC
    }.freeze
    DIRECTIVE_REGEXP  = /((#{DIRECTIVE_PROCS.keys.join("|")})(.*?));/i

    def content_security_policy(policy = nil)
      if !policy.nil? && HanamiWebpack::Config.using_dev_server?
        policy = policy.gsub(DIRECTIVE_REGEXP) do |m|
          processor = DIRECTIVE_PROCS[$2] || proc { m }
          processor.call($1.strip) + ";"
        end
      end

      super(policy)
    end
  end
end
