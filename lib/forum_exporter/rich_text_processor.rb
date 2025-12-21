require 'nokogiri'
require 'globalid'

class ForumExporter
  class RichTextProcessor
    def initialize(image_downloader, logger)
      @image_downloader = image_downloader
      @logger = logger
      @attachment_mapping = {}
    end

    attr_reader :attachment_mapping

    def process_post_text(post)
      return '' unless post.text.present?

      html = post.text.body.to_s
      doc = Nokogiri::HTML.fragment(html)

      # Find all action-text-attachment elements
      attachment_tags = doc.css('action-text-attachment')

      if attachment_tags.empty?
        return html
      end

      @logger.info("Processing #{attachment_tags.size} attachments in post #{post.id}")

      attachment_tags.each_with_index do |attachment_tag, index|
        process_attachment(attachment_tag, post, index + 1)
      end

      doc.to_html
    end

    private

    def process_attachment(tag, post, index)
      sgid_string = tag['sgid']
      filename = tag['filename'] || 'unknown'

      unless sgid_string
        @logger.warn("Post #{post.id}: Attachment #{index} missing SGID, skipping")
        return
      end

      begin
        # Decode SGID to get the blob
        sgid = GlobalID::Locator.locate_signed(sgid_string)

        unless sgid.is_a?(ActiveStorage::Blob)
          @logger.error("Post #{post.id}: SGID resolved to #{sgid.class}, expected ActiveStorage::Blob")
          tag.replace(placeholder_image(filename, 'Invalid attachment type'))
          return
        end

        blob = sgid

        # Download the image
        relative_path = @image_downloader.download_embedded_image(blob, post, index)

        if relative_path
          # Store mapping
          @attachment_mapping[sgid_string] = relative_path

          # Replace the action-text-attachment tag with a standard img tag
          # Use relative path from CSV directory (../../images/...)
          img_src = File.join('..', '..', relative_path)
          img_tag = "<img src=\"#{img_src}\" alt=\"#{filename}\" class=\"action-text-attachment\" />"

          tag.replace(img_tag)
        else
          # Download failed, use placeholder
          tag.replace(placeholder_image(filename, 'Download failed'))
        end

      rescue => e
        @logger.error("Post #{post.id}: Error processing attachment #{index}: #{e.message}")
        tag.replace(placeholder_image(filename, e.message))
      end
    end

    def placeholder_image(filename, error)
      "<img src=\"MISSING\" alt=\"#{filename}\" class=\"missing-attachment\" data-error=\"#{error}\" />"
    end
  end
end
