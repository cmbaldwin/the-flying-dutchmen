require_relative 'forum_exporter/logger'
require_relative 'forum_exporter/csv_writer'
require_relative 'forum_exporter/json_writer'
require_relative 'forum_exporter/image_downloader'
require_relative 'forum_exporter/orphaned_images_downloader'
require_relative 'forum_exporter/rich_text_processor'

class ForumExporter
  def initialize(export_path = Rails.root.join('export'))
    @export_path = export_path.to_s
    @logger = ForumExporter::Logger.new(@export_path)
    @image_downloader = ForumExporter::ImageDownloader.new(@export_path, @logger)
    @orphaned_images_downloader = ForumExporter::OrphanedImagesDownloader.new(@export_path, @logger, @image_downloader)
    @rich_text_processor = ForumExporter::RichTextProcessor.new(@image_downloader, @logger)
    @stats = {}
    @start_time = Time.now
  end

  attr_reader :logger, :stats

  def export!
    @logger.info('=' * 60)
    @logger.info('Starting forum export')
    @logger.info('=' * 60)

    setup_directories
    export_users
    export_categories
    export_threads
    export_posts
    export_orphaned_images
    generate_manifest
    generate_statistics

    @logger.info('=' * 60)
    @logger.info('Export complete!')
    @logger.info("Duration: #{duration_string}")
    @logger.info("Location: #{@export_path}")
    @logger.info('=' * 60)
    @logger.close

    @stats
  end

  def export_users
    @logger.info('Exporting users...')

    headers = %w[id email username moderator settings_json avatar_path created_at updated_at]
    csv = ForumExporter::CSVWriter.new(
      File.join(@export_path, 'csv', 'users.csv'),
      headers
    )
    json = ForumExporter::JSONWriter.new(
      File.join(@export_path, 'json', 'users.json'),
      headers
    )

    count = 0
    User.find_each do |user|
      avatar_path = @image_downloader.download_avatar(user)

      row_data = [
        user.id,
        user.email,
        user.username,
        user.moderator,
        user.settings.to_json,
        avatar_path,
        user.created_at,
        user.updated_at
      ]

      csv.write_row(row_data)
      json.write_row(row_data)

      count += 1
    end

    csv.close
    json.close
    @stats[:users] = count
    @logger.info("Exported #{count} users")
  end

  def export_categories
    @logger.info('Exporting forum categories...')

    headers = %w[id name slug color created_at updated_at]
    csv = ForumExporter::CSVWriter.new(
      File.join(@export_path, 'csv', 'forum_categories.csv'),
      headers
    )
    json = ForumExporter::JSONWriter.new(
      File.join(@export_path, 'json', 'forum_categories.json'),
      headers
    )

    count = 0
    ForumCategory.find_each do |category|
      row_data = [
        category.id,
        category.name,
        category.slug,
        category.color,
        category.created_at,
        category.updated_at
      ]

      csv.write_row(row_data)
      json.write_row(row_data)

      count += 1
    end

    csv.close
    json.close
    @stats[:categories] = count
    @logger.info("Exported #{count} categories")
  end

  def export_threads
    @logger.info('Exporting forum threads...')

    headers = %w[id forum_category_id user_id title slug forum_posts_count pinned solved created_at updated_at]
    csv = ForumExporter::CSVWriter.new(
      File.join(@export_path, 'csv', 'forum_threads.csv'),
      headers
    )
    json = ForumExporter::JSONWriter.new(
      File.join(@export_path, 'json', 'forum_threads.json'),
      headers
    )

    count = 0
    ForumThread.find_each do |thread|
      row_data = [
        thread.id,
        thread.forum_category_id,
        thread.user_id,
        thread.title,
        thread.slug,
        thread.forum_posts_count,
        thread.pinned,
        thread.solved,
        thread.created_at,
        thread.updated_at
      ]

      csv.write_row(row_data)
      json.write_row(row_data)

      count += 1
    end

    csv.close
    json.close
    @stats[:threads] = count
    @logger.info("Exported #{count} threads")
  end

  def export_posts
    @logger.info('Exporting forum posts (this may take a while)...')

    headers = %w[id forum_thread_id user_id text_html solved created_at updated_at]
    csv = ForumExporter::CSVWriter.new(
      File.join(@export_path, 'csv', 'forum_posts.csv'),
      headers
    )
    json = ForumExporter::JSONWriter.new(
      File.join(@export_path, 'json', 'forum_posts.json'),
      headers
    )

    count = 0
    ForumPost.find_each do |post|
      # Process rich text to extract and download images
      text_html = @rich_text_processor.process_post_text(post)

      row_data = [
        post.id,
        post.forum_thread_id,
        post.user_id,
        text_html,
        post.solved,
        post.created_at,
        post.updated_at
      ]

      csv.write_row(row_data)
      json.write_row(row_data)

      count += 1

      # Log progress every 50 posts
      @logger.info("Processed #{count} posts...") if count % 50 == 0
    end

    csv.close
    json.close
    @stats[:posts] = count
    @logger.info("Exported #{count} posts")
  end

  def export_orphaned_images
    @orphaned_images_downloader.download_orphaned_images
    @orphaned_images_downloader.save_metadata
    @stats[:orphaned_images] = @orphaned_images_downloader.downloaded_count
  end

  def clean!
    if File.directory?(@export_path)
      @logger.info("Removing existing export directory: #{@export_path}")
      FileUtils.rm_rf(@export_path)
      @logger.info('Directory removed')
    else
      @logger.info('No existing export directory to clean')
    end
  end

  private

  def setup_directories
    @logger.info("Creating export directory structure at: #{@export_path}")

    FileUtils.mkdir_p(File.join(@export_path, 'csv'))
    FileUtils.mkdir_p(File.join(@export_path, 'json'))
    FileUtils.mkdir_p(File.join(@export_path, 'images', 'users'))
    FileUtils.mkdir_p(File.join(@export_path, 'images', 'posts'))
    FileUtils.mkdir_p(File.join(@export_path, 'images', 'unassigned'))
    FileUtils.mkdir_p(File.join(@export_path, 'metadata'))

    @logger.info('Directory structure created')
  end

  def generate_manifest
    @logger.info('Generating README...')

    content = <<~README
      # Forum Export Archive

      **Export Date:** #{Time.now.utc}
      **Source Database:** the-flying-dutchmen (local development)
      **Export Version:** 1.0

      ## Contents

      - **#{@stats[:users]} users** (#{@image_downloader.downloaded_count - count_post_images} with avatars)
      - **#{@stats[:categories]} forum categories**
      - **#{@stats[:threads]} forum threads**
      - **#{@stats[:posts]} forum posts** (with embedded images)
      - **#{@stats[:orphaned_images]} unassigned images** (in database but failed to download normally)
      - **Total Images Downloaded:** #{@image_downloader.downloaded_count + @orphaned_images_downloader.downloaded_count}
      - **Failed Downloads:** #{@image_downloader.failed_count + @orphaned_images_downloader.failed_count}

      ## Directory Structure

      ```
      export/
      ├── README.md                    # This file
      ├── csv/
      │   ├── users.csv               # User accounts
      │   ├── forum_categories.csv    # Forum categories
      │   ├── forum_threads.csv       # Discussion threads
      │   └── forum_posts.csv         # Individual posts with HTML content
      ├── json/
      │   ├── users.json              # User accounts (JSON format)
      │   ├── forum_categories.json   # Forum categories (JSON format)
      │   ├── forum_threads.json      # Discussion threads (JSON format)
      │   └── forum_posts.json        # Individual posts with HTML content (JSON format)
      ├── images/
      │   ├── users/{user_id}/avatar.{ext}
      │   ├── posts/{post_id}/image_{n}.{ext}
      │   └── unassigned/{key}.{ext}  # Orphaned images from GCS
      └── metadata/
          ├── export_log.txt          # Detailed export log
          ├── attachment_mapping.json # SGID to file path mapping
          ├── unassigned_images.json  # Metadata for unassigned images
          └── statistics.json         # Export statistics
      ```

      ## Data Files

      All data is exported in both CSV and JSON formats for maximum compatibility.

      ### users.csv / users.json
      Fields: id, email, username, moderator, settings_json, avatar_path, created_at, updated_at

      - `avatar_path`: Relative path to user's avatar image (if they have one)
      - `settings_json`: User settings as JSON string

      ### forum_categories.csv / forum_categories.json
      Fields: id, name, slug, color, created_at, updated_at

      - `color`: Hex color code for category display

      ### forum_threads.csv / forum_threads.json
      Fields: id, forum_category_id, user_id, title, slug, forum_posts_count, pinned, solved, created_at, updated_at

      - `forum_category_id`: Foreign key to forum_categories
      - `user_id`: Foreign key to users (thread author)
      - `pinned`: Boolean indicating if thread is pinned to top
      - `solved`: Boolean indicating if thread is marked as solved

      ### forum_posts.csv / forum_posts.json
      Fields: id, forum_thread_id, user_id, text_html, solved, created_at, updated_at

      - `forum_thread_id`: Foreign key to forum_threads
      - `user_id`: Foreign key to users (post author)
      - `text_html`: Rich text content as HTML with local image paths
      - `solved`: Boolean indicating if this post solved the thread

      ## Images

      All images have been downloaded from Google Cloud Storage and organized locally:

      - **User avatars:** `images/users/{user_id}/avatar.{ext}`
      - **Post images:** `images/posts/{post_id}/image_{n}.{ext}`
      - **Unassigned images:** `images/unassigned/{key}.{ext}` - Images that exist in ActiveStorage but failed to download during normal export

      Image paths in `forum_posts.csv` are relative paths from the CSV directory, e.g., `../../images/posts/5/image_1.jpg`

      ### Unassigned Images

      Some images exist in the ActiveStorage database but couldn't be associated with specific users or posts during export. These may be:
      - Attachments whose SGID references were broken or corrupted
      - Images from deleted posts that still have database records
      - Failed rich text associations

      All unassigned images are saved in `images/unassigned/` with their GCS key as the filename.
      Full metadata (including original filenames, content types, blob IDs, and checksums) is available in `metadata/unassigned_images.json`.

      ## Notes

      - All timestamps are in UTC
      - Foreign key relationships are preserved via ID fields
      - Rich text HTML has been processed to use local image paths instead of GCS URLs
      - Missing or failed downloads are marked with `<img src="MISSING" ...>` tags
      - Original ActionText blob SGIDs are mapped in `metadata/attachment_mapping.json`

      ## Using This Export

      ### Viewing Content
      - CSV files can be opened in Excel, Google Sheets, or any CSV viewer
      - JSON files can be parsed by any programming language or JSON viewer
      - HTML content in forum_posts can be rendered in a browser
      - Images can be viewed directly from the images/ folder

      ### Re-importing
      This export format preserves all foreign key relationships and can be used to:
      - Import into a new Rails application
      - Migrate to a different database system
      - Archive the forum content
      - Analyze forum data

      ## Export Statistics

      - Duration: #{duration_string}
      - Images Downloaded: #{@image_downloader.downloaded_count}
      - Orphaned Images Downloaded: #{@orphaned_images_downloader.downloaded_count}
      - Images Failed: #{@image_downloader.failed_count + @orphaned_images_downloader.failed_count}
      - Total Records: #{@stats.values.sum}

      For detailed logs, see `metadata/export_log.txt`
    README

    File.write(File.join(@export_path, 'README.md'), content)
    @logger.info('README generated')
  end

  def generate_statistics
    @logger.info('Generating statistics...')

    stats_data = {
      export_date: Time.now.utc.iso8601,
      duration_seconds: (Time.now - @start_time).round(2),
      counts: @stats,
      images: {
        downloaded: @image_downloader.downloaded_count,
        failed: @image_downloader.failed_count,
        orphaned_downloaded: @orphaned_images_downloader.downloaded_count,
        orphaned_failed: @orphaned_images_downloader.failed_count
      },
      attachment_mapping: @rich_text_processor.attachment_mapping
    }

    File.write(
      File.join(@export_path, 'metadata', 'statistics.json'),
      JSON.pretty_generate(stats_data)
    )

    File.write(
      File.join(@export_path, 'metadata', 'attachment_mapping.json'),
      JSON.pretty_generate(@rich_text_processor.attachment_mapping)
    )

    @logger.info('Statistics generated')
  end

  def count_post_images
    # Count images in posts directory
    post_images_dir = File.join(@export_path, 'images', 'posts')
    return 0 unless File.directory?(post_images_dir)

    Dir.glob(File.join(post_images_dir, '**', '*')).count { |f| File.file?(f) }
  end

  def duration_string
    duration = (Time.now - @start_time).round
    minutes = duration / 60
    seconds = duration % 60

    if minutes > 0
      "#{minutes}m #{seconds}s"
    else
      "#{seconds}s"
    end
  end
end
