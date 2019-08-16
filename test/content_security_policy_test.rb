require "test_helper"

class ContentSecurityPolicyTest < Test::Unit::TestCase
  def security
    @security ||= Hanami::Config::Security.new.tap do |s|
      s.content_security_policy %{
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.googletagmanager.com/gtag/js?id=UA-XXX-Y;
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self' https:;
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      }
    end
  end

  def test_hijack
    expected = %{
      form-action 'self';
      frame-ancestors 'self';
      base-uri 'self';
      default-src 'none';
      script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.googletagmanager.com/gtag/js?id=UA-XXX-Y http://test.host:54321;
      connect-src 'self' http://test.host:54321 ws://test.host:54321;
      img-src 'self' https: data:;
      style-src 'self' 'unsafe-inline' https: http://test.host:54321;
      font-src 'self' https: http://test.host:54321;
      object-src 'none';
      plugin-types application/pdf;
      child-src 'self';
      frame-src 'self';
      media-src 'self'
    }.split(Hanami::Config::Security::SEPARATOR).map(&:strip).join(Hanami::Config::Security::SPACED_SEPARATOR)
    assert_equal security.content_security_policy, expected
  end
end
