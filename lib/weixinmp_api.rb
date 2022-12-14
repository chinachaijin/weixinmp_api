require "rest-client"
require "carrierwave"
if defined? Yajl
  require 'yajl/json_gem'
else
  require "json"
end
require "erb"

require "weixinmp_api/carrierwave/weixin_uploader"
require "weixinmp_api/config"
require "weixinmp_api/handler"
require "weixinmp_api/api"
require "weixinmp_api/client"

module WeixinmpApi

  # token store
  module Token
    autoload(:Store,       "weixinmp_api/token/store")
    autoload(:ObjectStore, "weixinmp_api/token/object_store")
    autoload(:RedisStore,  "weixinmp_api/token/redis_store")
  end

  module JsTicket
    autoload(:Store,       "weixinmp_api/js_ticket/store")
    autoload(:ObjectStore, "weixinmp_api/js_ticket/object_store")
    autoload(:RedisStore,  "weixinmp_api/js_ticket/redis_store")
  end

  OK_MSG  = "ok".freeze
  OK_CODE = 0.freeze
  GRANT_TYPE = "client_credential".freeze
  # 用于标记endpoint可以直接使用url作为完整请求API
  CUSTOM_ENDPOINT = "custom_endpoint".freeze

  class << self

    def http_get_without_token(url, url_params={}, endpoint="plain")
      get_api_url = endpoint_url(endpoint, url)
      load_json(resource(get_api_url).get(params: url_params))
    end

    def http_post_without_token(url, post_body={}, url_params={}, endpoint="plain")
      post_api_url = endpoint_url(endpoint, url)
      # to json if invoke "plain"
      if endpoint == "plain" || endpoint == CUSTOM_ENDPOINT
        post_body = JSON.dump(post_body)
      end
      load_json(resource(post_api_url).post(post_body, params: url_params))
    end

    def resource(url)
      RestClient::Resource.new(url, rest_client_options)
    end

    # return hash
    def load_json(string)
      result_hash = JSON.parse(string.force_encoding("UTF-8").gsub(/[\u0011-\u001F]/, ""))
      code   = result_hash.delete("errcode")
      en_msg = result_hash.delete("errmsg")
      ResultHandler.new(code, en_msg, result_hash)
    end

    def endpoint_url(endpoint, url)
      # 此处为了应对第三方开发者如果自助对接接口时，URL不规范的情况下，可以直接使用URL当为endpoint
      return url if endpoint == CUSTOM_ENDPOINT
      send("#{endpoint}_endpoint") + url
    end

    def plain_endpoint
      "#{api_endpoint}/cgi-bin"
    end

    def api_endpoint
      "https://api.weixin.qq.com"
    end

    def file_endpoint
      "http://file.api.weixin.qq.com/cgi-bin"
    end

    def mp_endpoint(url)
      "https://mp.weixin.qq.com/cgi-bin#{url}"
    end

    def open_endpoint(url)
      "https://open.weixin.qq.com#{url}"
    end

    def calculate_expire(expires_in)
      Time.now.to_i + expires_in.to_i - key_expired.to_i
    end

  end

end
