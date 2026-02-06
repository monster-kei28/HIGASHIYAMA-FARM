OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
  provider: "line",
  uid: "U-test-uid-123",
  info: {
    name: "LINE表示名（今回は使わない）"
  }
)
