# encoding: utf-8
module WeixinmpApi
  module Api
    module User

      # 获取用户基本信息
      # https://api.weixin.qq.com/cgi-bin/user/info?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
      # lang: zh_CN, zh_TW, en
      def user(openid, lang="zh_CN")
        user_info_url = "#{user_base_url}/info"
        http_get(user_info_url, {openid: openid, lang: lang})
      end

      # 批量获取用户基本信息
      # https://api.weixin.qq.com/cgi-bin/user/info/batchget?access_token=ACCESS_TOKEN
      # POST数据格式：JSON
      # POST数据例子：
        # {
        #   "user_list": [
        #     {
        #       "openid": "otvxTs4dckWG7imySrJd6jSi0CWE",
        #       "lang": "zh-CN"
        #     },
        #     {
        #       "openid": "otvxTs_JZ6SEiP0imdhpi50fuSZg",
        #       "lang": "zh-CN"
        #     }
        #   ]
        # }
      def users(user_list)
        user_info_batchget_url = "#{user_base_url}/info/batchget"
        post_body = user_list
        http_post(user_info_batchget_url, post_body)
      end

      # 获取关注者列表
      # https://api.weixin.qq.com/cgi-bin/user/get?access_token=ACCESS_TOKEN&next_openid=NEXT_OPENID
      def followers(next_openid="")
        followers_url = "#{user_base_url}/get"
        http_get(followers_url, {next_openid: next_openid})
      end

      # 设置备注名
      # http请求方式: POST（请使用https协议）
      # https://api.weixin.qq.com/cgi-bin/user/info/updateremark?access_token=ACCESS_TOKEN
      # POST数据格式：JSON
      # POST数据例子：
      # {
      #   "openid":"oDF3iY9ffA-hqb2vVvbr7qxf6A0Q",
      #   "remark":"pangzi"
      # }
      def update_remark(openid, remark)
        update_url = "/user/info/updateremark"
        post_body = {
          openid: openid,
          remark: remark
        }
        http_post(update_url, post_body)
      end

      private

        def user_base_url
          "/user"
        end

    end
  end
end
