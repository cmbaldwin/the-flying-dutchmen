class ForumExporter
  class OrphanedImagesDownloader
    MAX_RETRIES = 3
    RETRY_DELAY = 1

    def initialize(export_path, logger, image_downloader)
      @export_path = export_path
      @logger = logger
      @image_downloader = image_downloader
      @downloaded_count = 0
      @failed_count = 0
      @metadata = []
      @gcs_client = nil
    end

    attr_reader :downloaded_count, :failed_count, :metadata

    def download_orphaned_images
      @logger.info('Searching for images in ActiveStorage that were not downloaded...')

      begin
        # Get all blob keys from ActiveStorage database
        all_blob_keys = ActiveStorage::Blob.pluck(:key, :id).to_h
        @logger.info("Found #{all_blob_keys.count} blobs in ActiveStorage database")

        # Get the set of already downloaded blob keys from the image downloader
        downloaded_keys = @logger.instance_variable_get(:@image_downloader)&.downloaded_blob_keys || Set.new

        # Find blobs that weren't downloaded
        missing_blob_keys = all_blob_keys.keys - downloaded_keys.to_a

        @logger.info("Found #{missing_blob_keys.count} blobs that were not downloaded")

        if missing_blob_keys.empty?
          @logger.info('All ActiveStorage blobs were already downloaded')
          return
        end

        # Download each missing image
        missing_blob_keys.each_with_index do |key, index|
          blob_id = all_blob_keys[key]
          blob = ActiveStorage::Blob.find_by(id: blob_id)

          if blob
            download_missing_blob(blob, index + 1)
          else
            @logger.warn("Blob #{blob_id} not found, skipping")
          end
        end

        @logger.info("Downloaded #{@downloaded_count} missing images")
        @logger.info("Failed to download #{@failed_count} missing images") if @failed_count > 0
      rescue StandardError => e
        @logger.error("Error accessing ActiveStorage blobs: #{e.message}")
        @logger.error(e.backtrace.join("\n"))
      end
    end

    def save_metadata
      return if @metadata.empty?

      metadata_file = File.join(@export_path, 'metadata', 'unassigned_images.json')
      File.write(metadata_file, JSON.pretty_generate(@metadata))
      @logger.info("Saved unassigned images metadata to #{File.basename(metadata_file)}")
    end

    private

    def download_missing_blob(blob, index)
      retries = 0

      begin
        # Determine file extension
        extension = File.extname(blob.filename.to_s)
        extension = '.bin' if extension.empty?

        # Create sanitized filename using blob key
        safe_key = blob.key.gsub(/[^0-9a-z]/i, '_')
        filename = "#{safe_key}#{extension}"
        destination = File.join(@export_path, 'images', 'unassigned', filename)

        # Ensure directory exists
        FileUtils.mkdir_p(File.dirname(destination))

        # Download blob data from ActiveStorage
        blob.open do |file|
          FileUtils.cp(file.path, destination)
        end

        @downloaded_count += 1
        @logger.info("Downloaded unassigned image #{index}: #{filename}")

        # Collect metadata
        @metadata << {
          blob_id: blob.id,
          blob_key: blob.key,
          downloaded_filename: filename,
          original_filename: blob.filename.to_s,
          content_type: blob.content_type,
          byte_size: blob.byte_size,
          checksum: blob.checksum,
          created_at: blob.created_at&.iso8601,
          metadata: blob.metadata
        }

        true
      rescue StandardError => e
        retries += 1

        if retries <= MAX_RETRIES
          @logger.warn("Failed to download blob #{blob.key} (attempt #{retries}/#{MAX_RETRIES}): #{e.message}")
          sleep(RETRY_DELAY * retries)
          retry
        else
          @failed_count += 1
          @logger.error("Failed to download blob #{blob.key} after #{MAX_RETRIES} attempts: #{e.message}")
          false
        end
      end
    end

    def extension_from_content_type(content_type)
      return nil unless content_type

      case content_type
      when /jpeg|jpg/ then '.jpg'
      when /png/ then '.png'
      when /gif/ then '.gif'
      when /webp/ then '.webp'
      when /svg/ then '.svg'
      when /bmp/ then '.bmp'
      when /tiff/ then '.tiff'
      when /pdf/ then '.pdf'
      else nil
      end
    end

    def extension_from_key(key)
      # Try to extract extension from key if it has one
      match = key.match(/\.([a-z0-9]{2,4})$/i)
      match ? ".#{match[1]}" : nil
    end
  end
end
