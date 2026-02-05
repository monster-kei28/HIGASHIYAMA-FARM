Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line,
           ENV["LINE_CHANNEL_ID"],
           ENV["LINE_CHANNEL_SECRET"],
           scope: 'profile openid',
           prompt: 'consent'
end

OmniAuth.config.allowed_request_methods = [:post]
OmniAuth.config.silence_get_warning = true