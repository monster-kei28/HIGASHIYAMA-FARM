CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :aws
    config.aws_bucket = ENV.fetch("S3_BUCKET")

    config.aws_credentials = {
      access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      region: ENV.fetch("AWS_REGION")
    }
  else
    config.storage = :file
  end
end
