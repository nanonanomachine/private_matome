# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # Include Rmagick for resizing and converting image type
  include CarrierWave::RMagick

  # Set image width and height limit 700px
  process :resize_to_limit => [700, 700]

  # Creating a thumbnail
  version :thumb do
    process :check_extension
  end

  # Receive only jpg,jpeg,gif,png
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Check Extension
  def check_extension
    if file.extension.downcase == 'gif'
       fix_resize_issue_with_gif
    else
       resize_to_limit(400, 400)
    end
  end

  # Resize gif
  # http://stackoverflow.com/questions/20110337/resize-gif-file-without-distortion-with-rmagick-and-carrierwave
  def fix_resize_issue_with_gif
    if file.extension.downcase == 'gif' && version_name.blank?
      list = ::Magick::ImageList.new.from_blob file.read

      if list.size > 1
        list = list.coalesce
        File.open(current_path, 'wb') { |f| f.write list.to_blob }
      end
    end
  end
end
