module ApplicationHelper
  def thumbnail_url(image)
    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-100"
    else
      image&.file&.url(transformation: [{height: 100, width: 100, quality: 100, raw: "c-at_max,c-maintain_ratio"}])
    end
  end

  def large_url(image)
    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-400,w=400,c-maintain_ratio"
    else
      image&.file&.url(transformation: [{height: 400, width: 400, quality: 100, raw: "c-at_max,c-maintain_ratio"}])
    end
  end

  # image with 400px height and extra gray padding to maintain ratio
  def large_url_fix_h(image)
    if image&.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-400,c-maintain_ratio"
    else
      image&.file&.url(transformation: [{height: 400, width: 600, quality: 100, raw: "c-at_max,c-maintain_ratio,cm-pad_resize,bg-F3F3F3"}])
    end
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
end
