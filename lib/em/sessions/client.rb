require 'json'
module Em
  module Sessions
    class Client


      attr_reader :http_url, :app

      def initialize(url, app)
        if url.nil? || app.nil?
          raise 'http_url is blank or app is blank!'
        end
        if url.strip.empty?
          http_url = 'http://localhost:3000/'
        else
          http_url = url =~ /^https?\/\// ? url : "http://#{url}"
        end
        @app = app
        @http_url = http_url =~ /\/$/ ? http_url[0..-2] : http_url
      end

      def create(id,  out_time = 7200, ip = '0.0.0.0', app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/create/#{id}?ip=#{ip}&ttl=#{out_time}}
        return run_em 'put', run_http_url
      end

      def find_by_token(user_token, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/get/#{ user_token }}
        return run_em 'get', run_http_url
      end


      def find_by_id(id, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/soid/#{ id }}
        return run_em 'get', run_http_url
      end

      def delete_by_token(user_token, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/kill/#{ user_token }}
        return run_em 'delete', run_http_url
      end

      def delete_by_id(id, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/killsoid/#{ id }}
        return run_em 'delete', run_http_url
      end

      def delete_all(app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/killall}
        return run_em 'delete', run_http_url
      end

      def set_params_by_token(user_token, params = {}, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/set/#{ user_token }}
        return run_em 'post', run_http_url, { 'Content-Type'=>'application/json'}, params
      end

      def activity?(seconds = 600, app = nil)
        app_name =  get_app_name app
        run_http_url = %Q{#{@http_url}/#{app_name}/activity?dt=#{seconds}}
        return run_em 'get', run_http_url
      end

    private

      def get_app_name(app)
        app.nil? ? @app : app
      end

      def run_em(type, url, head = {}, body = {})
        code = 0
        return_string = ''
        EventMachine.run {
          http = EventMachine::HttpRequest.new(url).send type, head: head, body: body.to_json
          http.errback { code = http.response_header.status; return_string = http.response;EM.stop }
          http.callback { code = http.response_header.status; return_string = http.response;EventMachine.stop }
        }
        if code ==  200
          json = JSON.parse return_string
          return 200, json
        end
        return code, json
      end


    end


  end
end