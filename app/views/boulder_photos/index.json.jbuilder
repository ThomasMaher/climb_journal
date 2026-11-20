json.array! @boulder.boulder_photos.each do |photo|
  json.id photo.id
  json.caption photo.caption
  json.image_url rails_blob_url(
    photo.image,
    host: request.host_with_port,
    protocol: "http"
  )
end
