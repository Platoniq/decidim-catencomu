# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"
require "civicrm_api/civicrm_api"

module OmniAuth
  module Strategies
    class Civicrm < OmniAuth::Strategies::OAuth2
      args [:client_id, :client_secret, :site]

      option :name, :civicrm
      option :site, nil
      option :client_options, {}

      uid do
        raw_info["sub"]
      end

      info do
        json = CivicrmApi::Request.new.get_user(uid)
        user = CivicrmApi::Models::User.from_contact(json)

        {
          name: user[:name],
          nickname: user[:nickname],
          email: raw_info["email"],
          image: raw_info["picture"]
        }
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = URI.join(options.site, "/oauth2/authorize").to_s
        options.client_options[:token_url] = URI.join(options.site, "/oauth2/token").to_s
        super
      end

      def raw_info
        @raw_info ||= access_token.get("/oauth2/UserInfo").parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
