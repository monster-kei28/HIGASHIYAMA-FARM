class PageImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :aws
  else
    storage :file
  end

  process resize_to_limit: [1600, 900]
  process :convert_to_webp

  def extension_allowlist
    %w[jpg jpeg png webp]
  end

  def content_type_allowlist
    [/image\//]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    return unless original_filename.present?

    "#{secure_token}.webp"
  end

  def convert_to_webp
    manipulate! do |image|
      image.combine_options do |command|
        command.strip
        command.quality "85"
      end
      image.format("webp")
      image
    end
  end

  private

  def secure_token
    @secure_token ||= SecureRandom.uuid
  end
end
