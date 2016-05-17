require 'em-http-request'
require 'em/sessions/version'
require 'em/sessions/client'
module Em
  module Sessions
    class << self
      attr_reader :http_url, :client, :app
      def init(http_url = 'localhost:3000', app = 'weapp')
        @http_url ||= http_url
        @app = app
      end

      def client
        raise 'Please run Em::Sessions.init(http_url, app) method' if @http_url.empty? && @app.empty?
        @client ||= Client.new @http_url, @app
      end

      def modify_url(url)
        @http_url = url
        @client = nil
      end

      def modify_app(app)
        @app = app
        @client = nil
      end

    private
    end
  end
end