require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req) 
        my_cookie = req.cookies.find do |cookie| 
            cookie.name == "_rails_lite_app"
        end
        if my_cookie
            @cookie_hash = JSON.parse(my_cookie.value)
        else
            @cookie_hash = {}
        end
    end

    def [](key)
        @cookie_hash[key] 
    end

    def []=(key, val)
        @cookie_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
        cookie = WEBrick::Cookie.new(
        "_rails_lite_app",
        @cookie_hash.to_json)
        res.cookies << cookie
    end
  end
end


