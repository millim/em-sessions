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
        @client ||= Client.new @http_url, @app
      end

    private
    end
  end
end