require 'em-http-request'
require 'em/sessions/version'
require 'em/sessions/client'
module Em
  module Sessions
    class << self
      attr_accessor :last_client, :url, :app


      # if use init, every each call client, this client are same
      def init(url = 'localhost:3000', app = 'weapp')
        @url = url
        @app = app
      end

      def client(url = nil, app = nil)
        set_url = url.nil? ? @url : url
        set_app = app.nil? ? @app : app
        raise 'Please input url or app_name,such as: client("localhost:3000", "weapp")' if set_url.nil? || set_app.nil?
        @last_client = Client.new set_url, set_app
        @last_client
      end

    end
  end
end