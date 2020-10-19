# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class Request
        def initialize(params = {})
          @params = params
        end

        def get(extra_params = {})
          response ||= Faraday.get config[:url] do |request|
            request.params = request_params.merge(extra_params)
          end

          return raise Error, response.reason_phrase unless response.success?

          JSON.parse(response.body).to_h
        end

        def get_contact(id)
          response = get(entity: "Contact", contact_id: id, return: "roles")

          raise Error, "Malformed response in get_contact: #{response.to_json}" unless response.has_key?("values")

          response["values"][id.to_s]
        end

        def get_user(id, with_contact: true)
          response = get(entity: "User", id: id)

          raise Error, "Malformed response in get_user: #{response.to_json}" unless response.has_key?("values")

          @user = response["values"][id.to_s]

          return @user unless with_contact

          @contact = get_contact(@user["contact_id"])
          @user.merge(@contact)
        end

        private

        def request_params
          @params.reverse_merge(
            action: "Get",
            api_key: config[:api_key],
            key: config[:secret],
            json: @params.fetch(:json, true)
          )
        end

        def config
          Rails.application.secrets.verifications.dig(:civicrm)
        end

        attr_reader :response
      end
    end
  end
end
