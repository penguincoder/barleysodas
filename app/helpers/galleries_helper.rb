module GalleriesHelper
  def new_image_link
    link_to 'Upload Image', new_gallery_url
  end
end
