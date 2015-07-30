module Gerry
  class Client
    module Request
      # Get the mapped options.
      #
      # @param [Array] options the query parameters.
      # @return [String] the mapped options.
      def map_options(options)
        options.map{|v| "#{v}"}.join('&')
      end

      private
      class RequestError < StandardError
      end

      def get(url)
        if @username && @password
          auth = { username: @username, password: @password }
          response = self.class.get("/a#{url}", digest_auth: auth)
          parse(response)
        else
          response = self.class.get(url)
          parse(response)
        end
      end

      def put(url, body)
        if @username && @password
          auth = { username: @username, password: @password }
          response = self.class.put("/a#{url}",
            body: body.to_json,
            headers: { 'Content-Type' => 'application/json' },
            digest_auth: auth
          )
          parse(response)
        else
          response = self.class.put(url,
            body: body.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          parse(response)
        end
      end

      def post(url, body)
        if @username && @password
          auth = { username: @username, password: @password }
          response = self.class.post("/a#{url}",
            body: body.to_json,
            headers: { 'Content-Type' => 'application/json' },
            digest_auth: auth
          )
          parse(response)
        else
          response = self.class.post(url,
            body: body.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          parse(response)
        end
      end

      def parse(response)
        unless /2[0-9][0-9]/.match(response.code.to_s)
          raise_request_error(response)
        end
        if response.body
          source = remove_magic_prefix(response.body)
          if source.lines.count == 1 && !source.start_with?('{') && !source.start_with?('[')
            # Work around the JSON gem not being able to parse top-level values, see
            # https://github.com/flori/json/issues/206.
            source.gsub!(/^"|"$/, '')
          else
            JSON.parse(source)
          end
        else
          nil
        end
      end

      def raise_request_error(response)
        raise RequestError.new("There was a request error! Response was: #{response.message}")
      end

      def remove_magic_prefix(response_body)
        # We need to strip the magic prefix from the first line of the response, see
        # https://gerrit-review.googlesource.com/Documentation/rest-api.html#output.
        response_body.sub(/^\)\]\}'$/, '').strip!
      end
    end
  end
end
