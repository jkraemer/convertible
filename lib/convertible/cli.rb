require 'convertible/client'
require 'convertible/mime_types'

module Convertible
  class Cli
    def initialize(key, input, output = nil, options = {})
      @key = key
      @input = input
      @output = output
      @options = options
    end

    def convert
      unless @input == 'STDIN' || File.readable?(@input)
        raise ArgumentError, "cannot open #{@input} for reading"
      end
      check_mimetypes
      $stderr.puts "converting #{@input} to #{@output} with options #{@options.inspect}" if @options[:debug]
      data = @input == 'STDIN' ? $stdin.read : File.read(@input)
      response = client.convert data, @input_type, @output_type, @options
      if @output == 'STDOUT'
        $stdout << response
      else
        (File.open(@output, 'wb') << response).close
      end
    end

    def show
      check_mimetypes false, false
      if in_t = @input_type
        if out_t = @output_type
          if client.supported?(in_t, out_t)
            puts 'supported'
          else
            puts 'not supported' # no worky
          end
        else
          conversions = client.supported_conversions @input_type
          $stderr.puts "Supported output formats for #{@input_type}:"
          puts conversions.join(', ')
        end
      else
        conversions = client.supported_conversions
        $stderr.puts "Supported conversions:"
        conversions.keys.sort.each do |input|
          puts "#{input} => " << conversions[input].join(', ')
        end
      end
    end


    protected

    def client
      Client.new
    end

    def check_mimetypes(need_input = true, need_output = true)
      if need_input && @input == 'STDIN' && @options[:input_type].nil?
        raise ArgumentError.new("You need to specify the input mimetype using -i when reading from STDIN!") 
      end
      if @input != 'STDIN' || @options[:input_type]
        unless @input_type = MimeTypes::for(@options[:input_type] || @input)
          raise ArgumentError.new "Unsupported input file type"
        end
      end
      if need_output && @output == 'STDOUT' && @options[:output_type].nil?
        raise ArgumentError.new("You need to specify the output mimetype using -o when redirecting to STDOUT!") 
      end
      if @output != 'STDOUT' || @options[:output_type]
        unless @output_type = MimeTypes::for(@options[:output_type] || @output)
          raise ArgumentError.new "Unsupported output file type"
        end
      end
      if @options[:debug]
        $stderr.puts "input type: #{@input_type}\noutput type: #{@output_type}"
      end
    end

  end
end
