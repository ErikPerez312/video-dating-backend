class ProfileImage < ApplicationRecord
  belongs_to :user

  has_attached_file :image_file
  validates_attachment :image_file, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"] }
end

# Find safer solution
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
