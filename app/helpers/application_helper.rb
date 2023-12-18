module ApplicationHelper
  def thumbnail_url(image)
    if image.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-100"
    else
      image.file.url(transformation: [{height: 100, quality: 100, raw: "c-at_max"}])
    end
  end

  def large_url(image)
    if image.is_video?
      "#{image.file.url}/ik-thumbnail.jpg?tr=h-400"
    else
      image.file.url(transformation: [{height: 400, quality: 100, raw: "c-at_max"}])
    end
  end

  def asset_delete_text(i)
    if i.is_video?
      "Delete video"
    else
      "Delete image"
    end
  end
end
