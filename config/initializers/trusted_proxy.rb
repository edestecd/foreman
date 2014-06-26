# We are using HAProxy -> nginx -> Unicorn setup
# These hacks are necessary in Rails 3 to pass the client ip through X-Forwarded-For Header...
#

# Tell rack about trusted proxies for logging
# This may be fixed in newer rails 4 versions
# https://github.com/rails/rails/issues/5223
# ActionDispatch::Request extends Rack::Request so
# I had to change to ActionDispatch to get super working here
module ActionDispatch
  class Request
    def trusted_proxy?(ip)
      if Rails.application.config.action_dispatch.trusted_proxies
        ip =~ Rails.application.config.action_dispatch.trusted_proxies
      else
        super(ip)
      end
    end
  end
end

# Copied from Rails 4 - remove when upgrade
# This allows us to override trusted proxies with regex (set in config/environments)
module ActionDispatch
  class RemoteIp
    def initialize(app, check_ip_spoofing = true, custom_proxies = nil)
      @app = app
      @check_ip = check_ip_spoofing
      @proxies = case custom_proxies
        when Regexp
          custom_proxies
        when nil
          TRUSTED_PROXIES
        else
          Regexp.union(TRUSTED_PROXIES, custom_proxies)
        end
    end
  end
end
