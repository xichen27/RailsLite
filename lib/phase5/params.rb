require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      @params.merge!(route_params)
      if req.body
        p parse_www_encoded_form(req.body)

        @params.merge!(parse_www_encoded_form(req.body))
      elsif req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      URI.decode_www_form(www_encoded_form).each do |key_str| #{[user[address][street], 1], [user[address][zip], 2] }
        key_set = parse_key(key_str[0])
        value = key_str[1]
        current = params

        key_set[0..-2].each do |key|
          current[key] ||= {}
          current = current[key]
        end 
          current[key_set[-1]] = value
      end
      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
        key.gsub("]", "").split('[')
    end
  end
end
