module ApplicationHelper
  def thumbnail_url(image)
    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-100"
    else
      image&.file&.url(transformation: [{height: 100, width: 100, quality: 100, raw: "c-at_max,c-maintain_ratio"}])
    end
  rescue => e
    Rails.logger.error("thumbnail_url failed for Image ID #{image.id}: #{e}")
    ""
  end

  def large_url(image)
    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-400,w=400,c-maintain_ratio"
    else
      image&.file&.url(transformation: [{height: 400, width: 400, quality: 100, raw: "c-at_max,c-maintain_ratio"}])
    end
  rescue => e
    Rails.logger.error("large_url failed for Image ID #{image.id}: #{e}")
    ""
  end

  # image with 400px height and extra gray padding to maintain ratio
  def large_url_fix_h(image)
    return "1x1.png" if image.blank?

    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-400,c-maintain_ratio"
    else
      image&.file&.url(transformation: [{height: 400, width: 600, quality: 100, raw: "c-at_max,c-maintain_ratio,cm-pad_resize,bg-F3F3F3"}])
    end
  rescue => e
    Rails.logger.error("large_url_fix_h failed for Image ID #{image.id}: #{e}")
    ""
  end

  def asset_delete_text(i)
    if i.is_video?
      "Delete video"
    else
      "Delete image"
    end
  end

  def is_production?
    hostname = ENV.fetch("HOSTNAME", "")
    hostname !~ /staging/
  end

  def yesno(b)
    b ? "Yes" : "No"
  end
end
