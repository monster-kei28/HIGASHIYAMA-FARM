CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :aws
  else
    config.storage = :file
  end
end
