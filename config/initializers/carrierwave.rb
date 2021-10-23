# Uncomment to use carrierwave to gevenerate model attachment uploaders
# CarrierWave.configure do |config|
#   config.storage                             = :gcloud
#   config.gcloud_bucket                       = ENV['GCLOUD_BUCKET']
#   config.gcloud_bucket_is_public             = true
#   config.gcloud_authenticated_url_expiration = 600
#   config.gcloud_content_disposition          = 'attachment'
  
#   config.gcloud_attributes = {
#     expires: 600
#   }
  
#   config.gcloud_credentials = {
#     gcloud_project: ENV['GCLOUD_PROJECT'],
#     gcloud_keyfile: ENV['GCLOUD_KEYFILE']
#   }
# end