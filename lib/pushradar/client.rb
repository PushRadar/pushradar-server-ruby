require 'net/http'
require 'json'
require 'cgi'

module PushRadar
  class Client
    def initialize(secret_key)
      unless secret_key.is_a?(String)
        raise PushRadar::Error, 'Secret key must be a string.'
      end

      unless secret_key.start_with?('sk_')
        raise PushRadar::Error, 'Please provide your PushRadar secret key. You can find it on the API page of your dashboard.'
      end

      @secret_key = secret_key
      @api_endpoint = 'https://api.pushradar.com/v3'
    end

    def validate_channel_name(channel_name)
      if /[^A-Za-z0-9_\-=@,.;]/.match(channel_name)
        raise PushRadar::Error, "Invalid channel name: #{channel_name}. Channel names cannot contain spaces, and must consist of only " +
          "upper and lowercase letters, numbers, underscores, equals characters, @ characters, commas, periods, semicolons, " +
          "and hyphens (A-Za-z0-9_=@,.;-)."
      end
    end

    def broadcast(channel_name, data)
      unless channel_name.is_a?(String)
        raise PushRadar::Error, 'Channel name must be a string.'
      end

      if channel_name.nil? || channel_name.strip.empty?
        raise PushRadar::Error, 'Channel name empty. Please provide a channel name.'
      end

      validate_channel_name(channel_name)
      response = do_http_request('POST', @api_endpoint + "/broadcasts", { channel: channel_name, data: data.to_json })

      if response[:status] === 200
        true
      else
        raise PushRadar::Error, 'An error occurred while calling the API. Server returned: ' + response[:body]
      end
    end

    def auth(channel_name, socket_id)
      unless channel_name.is_a?(String)
        raise PushRadar::Error, 'Channel name must be a string.'
      end

      if channel_name.nil? || channel_name.strip.empty?
        raise PushRadar::Error, 'Channel name empty. Please provide a channel name.'
      end

      unless channel_name.start_with?('private-')
        raise PushRadar::Error, 'Channel authentication can only be used with private channels.'
      end

      unless socket_id.is_a?(String)
        raise PushRadar::Error, 'Socket ID must be a string.'
      end

      if socket_id.nil? || socket_id.strip.empty?
        raise PushRadar::Error, 'Socket ID empty. Please pass through a socket ID.'
      end

      response = do_http_request('GET', @api_endpoint + "/channels/auth?channel=" + CGI.escape(channel_name) + "&socketID=" + CGI.escape(socket_id), {})
      if response[:status] === 200
         JSON(response[:body])['token']
      else
        raise PushRadar::Error, 'There was a problem receiving a channel authentication token. Server returned: ' + response[:body]
      end
    end

    def do_http_request(method, url, data)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      if method.downcase === 'post'
        req = Net::HTTP::Post.new(url)
        req['X-PushRadar-Library'] = 'pushradar-server-ruby ' + VERSION
        req['Authorization'] = "Bearer " + @secret_key
        req.content_type = 'application/json'
        data = data.to_json
        req.body = data
      else
        req = Net::HTTP::Get.new(url)
        req['X-PushRadar-Library'] = 'pushradar-server-ruby ' + VERSION
        req['Authorization'] = "Bearer " + @secret_key
        req.content_type = 'application/json'
      end

      response = http.request(req)
      { body: response.body, status: response.code.to_i }
    end

    private :validate_channel_name, :do_http_request
  end
end