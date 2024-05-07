require 'urbanairship'
require 'base64'
require 'rest-client'

module Urbanairship
  class Oauth
    attr_accessor :client_id, :sub, :assertion_private_key, :ip_addresses, :scopes, :oauth_server

    # Initialize Oauth class
    #
    # @param [String] client_id The Client ID found when creating Oauth credentials in the dashboard.
    # @param [String] key The app key for the project.
    # @param [String] assertion_private_key The private key found when creating Oauth credentials in the dashboard. Used for assertion token auth.
    # @param [Array<String>] ip_addresses A list of CIDR representations of valid IP addresses to which the issued token is restricted. Example: ['24.20.40.0/22', '34.17.3.0/22']
    # @param [Array<String>] scopes A list of scopes to which the issued token will be entitled. Example: ['psh', 'lst']
    # @param [String] oauth_server The server to send Oauth token requests to. By default is 'oauth2.asnapius.com', but can be set to 'oauth2.asnapieu.com' if using the EU server.
    # @return [Object] Oauth object
    def initialize(client_id:, key:, assertion_private_key:, ip_addresses: [], scopes: [], oauth_server: Urbanairship.configuration.oauth_server)
      @grant_type = 'client_credentials'
      @client_id = client_id
      @assertion_private_key = assertion_private_key
      @ip_addresses = ip_addresses
      @scopes = scopes
      @sub = "app:#{key}"
      @oauth_server = oauth_server
      @token = nil
    end

    # Get an Oauth token from Airship Oauth servers.
    #
    # @return [String] JSON web token to be used in further Airship API requests.
    def get_token
      unless @token.nil?
        decoded_jwt = JWT.decode(@token, nil, false)
        current_time = Time.now.to_i
        expiry_time = decoded_jwt[0]['exp']

        if current_time < expiry_time
          return @token
        end
      end

      assertion_jwt = build_assertion_jwt

      url = "https://#{@oauth_server}/token"
      headers = {
        'Host': @oauth_server,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      }

      params = {
        method: :post,
        url: url,
        headers: headers,
        payload: {
          grant_type: @grant_type,
          assertion: assertion_jwt
        },
        timeout: 60
      }

      retries = 0
      max_retries = 3
      begin
        response = RestClient::Request.execute(params)
        @token = JSON.parse(response.body)['access_token']
        return @token
      rescue RestClient::ExceptionWithResponse => e
        if [400, 401, 406].include?(e.response.code)
          raise e
        else
          retries += 1
          if retries <= max_retries
            sleep(retries ** 2)
            retry
          else
            new_error = RestClient::Exception.new(e.response, e.response.code)
            new_error.message = "failed after 3 attempts with error: #{e}"
            raise new_error
          end
        end
      end
    end

    # Build an assertion JWT
    #
    # @return [String] Assertion JWT to be used when requesting an Oauth token from Airship servers.
    def build_assertion_jwt
      assertion_expiration = 61
      private_key = OpenSSL::PKey::EC.new(@assertion_private_key)

      headers = {
        alg: 'ES384',
        kid: @client_id
      }

      claims = {
        aud: "https://#{@oauth_server}/token",
        exp: Time.now.to_i + assertion_expiration,
        iat: Time.now.to_i,
        iss: @client_id,
        nonce: SecureRandom.uuid,
        sub: @sub
      }

      claims[:scope] = @scopes.join(' ') if @scopes.any?
      claims[:ipaddr] = @ip_addresses.join(' ') if @ip_addresses.any?

      JWT.encode(claims, private_key, 'ES384', headers)
    end

    # Verify a public key
    #
    # @param [String] key_id The key ID ('kid') found in the header when decoding an Oauth token granted from Airship's servers.
    # @return [String] The public key associated with the Key ID.
    def verify_public_key(key_id)
      url = "https://#{@oauth_server}/verify/public_key/#{key_id}"

      headers = {
        'Host': @oauth_server,
        'Accept': 'text/plain'
      }

      response = RestClient.get(url, headers)
      response.body
    end
  end
end
