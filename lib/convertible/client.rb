require 'httparty'
require 'json'
require 'uri'

module Convertible
  API_ENDPOINT = 'http://api.convertible.io/'

  class Client
    include HTTParty
    base_uri API_ENDPOINT
    CONVERT = '/convert'

    # content_type and output_content_type must be valid mime types like 'application/pdf' or 'text/plain' 
    # if an URI instance is passed as data, the content will be fetched server side from said uri. content_type is 
    # ignored an should be nil in this case (convertible.io will use the content type from the remote resource).
    def convert(data, content_type, output_content_type, options = {})
      response = if URI === data
        self.class.get CONVERT, :headers => { 'Accept' => output_content_type,
                                              'X-Convert-Options' => option_string(options),
                                              'X-Source' => data.to_s }
      else
        self.class.post CONVERT, :body => data, :headers => { 'Content-Type' => content_type, 'Accept' => output_content_type, 'X-Convert-Options' => option_string(options) }
      end
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
