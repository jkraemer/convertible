require 'httparty'
require 'json'

module Convertible
  API_ENDPOINT = 'http://api.convertible.io/'

  class Client
    include HTTParty
    base_uri API_ENDPOINT

    # content_type and output_content_type must be valid mime types like 'application/pdf' or 'text/plain' 
    def convert(data, content_type, output_content_type, options = {})
      response = self.class.post '/convert', :body => data, :headers => { 'Content-Type' => content_type, 'Accept' => output_content_type, 'X-Convert-Options' => option_string(options) }
      if response.code == 200
        return response
      else
        false
      end
    end

    def supported_conversions(input_type = nil)
      if input_type
        response = self.class.get '/supported', :query => { :in => input_type }, :format => :json
        response['out']
      else
        response = self.class.get '/supported', :format => :json
        response['supported']
      end
    end

    def supported?(input_type, output_type)
      response = self.class.get '/supported', :query => { :in => input_type, :out => output_type }, :format => :json
      response['supported']
    end

    private
    def option_string(options = {})
      options.to_a.map{|opt| opt.join('=')}.join(';')
    end
  end
end
