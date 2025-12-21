class ForumExporter
  class ImageDownloader
    MAX_RETRIES = 3
    RETRY_DELAY = 1 # seconds

    def initialize(export_path, logger)
      @export_path = export_path
      @logger = logger
      @downloaded_count = 0
      @failed_count = 0
    end

    attr_reader :downloaded_count, :failed_count

    def download_avatar(user)
      return nil unless user.avatar.attached?

      blob = user.avatar.blob
      extension = File.extname(blob.filename.to_s)
      destination = File.join(@export_path, 'images', 'users', user.id.to_s, "avatar#{extension}")
      relative_path = File.join('images', 'users', user.id.to_s, "avatar#{extension}")

      if download_blob(blob, destination, "User #{user.id} avatar")
        relative_path
      else
        nil
      end
    end

    def download_embedded_image(blob, post, index)
      extension = File.extname(blob.filename.to_s)
      destination = File.join(@export_path, 'images', 'posts', post.id.to_s, "image_#{index}#{extension}")
      relative_path = File.join('images', 'posts', post.id.to_s, "image_#{index}#{extension}")

      if download_blob(blob, destination, "Post #{post.id} image #{index}")
        relative_path
      else
        nil
      end
    end

    private

    def download_blob(blob, destination, description)
      retries = 0

      begin
        # Ensure directory exists
        FileUtils.mkdir_p(File.dirname(destination))

        # Download blob data from ActiveStorage (GCS)
        blob.open do |file|
          FileUtils.cp(file.path, destination)
        end

        @downloaded_count += 1
        @logger.info("Downloaded #{description}: #{File.basename(destination)}")
        true

      rescue => e
        retries += 1

        if retries <= MAX_RETRIES
          @logger.warn("Failed to download #{description} (attempt #{retries}/#{MAX_RETRIES}): #{e.message}")
          sleep(RETRY_DELAY * retries) # Exponential backoff
          retry
        else
          @failed_count += 1
          @logger.error("Failed to download #{description} after #{MAX_RETRIES} attempts: #{e.message}")
          false
        end
      end
    end
  end
end
