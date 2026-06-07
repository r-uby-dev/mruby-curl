class Curl
  class URL
    ##
    # @param [String] url
    # @param [Hash] params
    # @return [Curl::URL]
    def initialize(url, params)
      @url = url
      @params = params
    end

    ##
    # @return [String]
    def encoded
      return url if params.nil? || params.empty?
      separator = url.include?("?") ? "&" : "?"
      "#{url}#{separator}#{encode_params(params)}"
    end

    private

    attr_reader :url, :params

    def encode_param(str)
      str.to_s.each_char.map { |c|
        case c
        when "A".."Z", "a".."z", "0".."9", "_", ".", "~", "-" then c
        when " " then "+"
        else sprintf("%%%02X", c.ord)
        end
      }.join
    end

    def encode_params(params)
      params.map { |k, v|
        "#{encode_param(k)}=#{encode_param(v)}"
      }.join("&")
    end
  end
end