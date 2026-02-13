require "net/http"
require "json"

module LineMessaging
  class PushText
    ENDPOINT = URI("https://api.line.me/v2/bot/message/push").freeze

    def self.call(to:, text:)
      new(to:, text:).call
    end

    def initialize(to:, text:)
      @to = to
      @text = text
    end

    def call
      token = ENV["LINE_MESSAGING_CHANNEL_ACCESS_TOKEN"]
      raise "LINE_MESSAGING_CHANNEL_ACCESS_TOKEN is missing" if token.nil? || token.empty?

      request = Net::HTTP::Post.new(ENDPOINT)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{token}"

      request.body = {
        to: @to,
        messages: [
          { type: "text", text: @text }
        ]
      }.to_json

      response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port, use_ssl: true) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "LINE push failed: #{response.code} #{response.body}"
      end

      true
    end
  end
end