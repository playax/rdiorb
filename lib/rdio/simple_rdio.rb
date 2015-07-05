# (c) 2011 Rdio Inc
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Changes by jeff@jeffpalm.com:
#
# - added module Rdio
# - changed class named from Rdio to SimpleRdio
#

require 'uri'
require 'net/http'
require 'cgi'
require 'json'

module Rdio

  class SimpleRdio
    # the consumer and token can be accessed
    attr_accessor :consumer, :token

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def begin_authentication(callback_url)
      # request a request token from the server
      response = signed_post('http://api.rdio.com/oauth/request_token',
                             {'oauth_callback' => callback_url})
      # parse the response
      parsed = CGI.parse(response)
      # save the token
      @token = [parsed['oauth_token'][0], parsed['oauth_token_secret'][0]]
      # return an URL that the user can use to authorize this application
      return parsed['login_url'][0] + '?oauth_token=' + parsed['oauth_token'][0]
    end

    def complete_authentication(verifier)
      # request an access token
      response = signed_post('http://api.rdio.com/oauth/access_token',
                             {'oauth_verifier' => verifier})
      # parse the response
      parsed = CGI.parse(response)
      # save the token
      @token = [parsed['oauth_token'][0], parsed['oauth_token_secret'][0]]
    end

    def call(method, params={})
      # make a copy of the dict
      params = params.clone
      # put the method in the dict
      params['method'] = method
      # call to the server and parse the response
      return JSON.load(signed_post('https://services.rdio.com/api/1/', params))
    end

    private

    def signed_post(url, params)
      unless @access_token
        req1 = RestClient.post("https://services.rdio.com/oauth2/token",
                      "grant_type=client_credentials&client_id=#{@client_id}&client_secret=#{@client_secret}")
        @access_token = JSON.parse(req1)["access_token"]
      end

      RestClient.post(url, params.merge!(access_token: @access_token))
    end

  end

end
